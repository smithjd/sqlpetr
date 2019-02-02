# local function to call Docker via `system2` and capture `stdout` and `stderr`
.system2_to_docker <- function(docker_cmd) {

  result <- system2("docker", docker_cmd, stdout = TRUE, stderr = TRUE)
  status <- attr(result, "status")

  # stop with the error message if the command failed
  if (length(status) > 0) {
    message(paste("command:", docker_cmd))
    message(paste("return:", result))
    stop(paste("Docker command failed with status", status))
  }

  # it worked - return the result
  return(result)
}

#' @title Build a Docker image
#' @name sp_docker_build
#' @description Creates a Docker image
#' @param build_options character: the build options. There are many; do
#' `docker build --help` at a command prompt to see them. You will need at least
#' the `--tag` option to give the built image a tag (name).
#' @param build_context_path character: the build context path
#' @return Result of Docker command if it succeeded. Stops with an error message
#' if it failed.
#' @importFrom glue glue
#' @export sp_docker_build

sp_docker_build <- function(build_options, build_context_path) {

  docker_cmd <- glue::glue(
    "build ", # docker build
    build_options, " ",
    build_context_path
  )
  result <- .system2_to_docker(docker_cmd)
}

#' @title Make `dvdrental` Docker image
#' @name sp_make_dvdrental_image
#' @description Creates a Docker image with PostgreSQL and the `dvdrental`
#' database
#' @param image_tag character: a valid image tag (name) for the docker image
#' @return Result of Docker command if it succeeded. Stops with an error message
#' if it failed.
#' @importFrom glue glue
#' @export sp_make_dvdrental_image
#' @examples
#' \dontrun{
#' build_log <- sp_make_dvdrental_image("test-dvdrental:latest")
#' sp_docker_images_tibble()
#' }
#' @details See the vignette "Building the `dvdrental` Docker Image" for the
#' details.

sp_make_dvdrental_image <- function(image_tag) {

  # compute path to Docker build context
  build_context_path <- paste(
    system.file(package = "sqlpetr"),
    "/extdata/docker",
    sep = "/"
  )

  build_options <- glue::glue(
    "--tag ", image_tag # gives the image a name
  )
  result <- sp_docker_build(build_options, build_context_path)
}

#' @title Run a Docker image
#' @name sp_docker_run
#' @description Creates a container and runs an image in it.
#' @param image_tag character: a valid image tag (name) for the docker image. If
#' it doesn't exist locally, `docker run` will try to download it. If the
#' download then fails, the function will stop with an error message.
#'
#' Note that the full syntax of an image tag is `<repository>/<name>:<tag>`. For
#' example, the PostgreSQL 10 image we use is `docker.io/postgres:10`.
#' @param options character: the options to use when running the image. Default
#' is the empty string. You will usually need at least the `--name` option to
#' give the container a name.
#' @param command character: the command to run after the container boots up.
#' Default is an empty string, which uses the startup command defined in the
#' image.
#' @param args character: the arguments for the command. Default is an empty
#' string.
#' @details Do `docker run --help` in a command prompt to see all the options,
#' of which there are many.
#' @return Result of Docker command if it succeeded. Stops with an error message
#' if it failed.
#' @importFrom glue glue
#' @export sp_docker_run
#' @examples
#' \dontrun{
#' print(sp_docker_run("hello-world"))
#' sp_docker_images_tibble()
#' }

sp_docker_run <- function(image_tag,
                          options = "",
                          command = "",
                          args = "") {
  docker_cmd <- glue::glue(
    "run ", # Run is the Docker command.
    options, " ",
    image_tag, " ",
    command, " ",
    args
  )
  result <- .system2_to_docker(docker_cmd)
}

#' @title Run a PostgreSQL Docker image in a container
#' @name sp_pg_docker_run
#' @description Creates a container and runs an image in it. The image
#' must be based on the `docker.io/postgres:10` image. It will run in the
#' background (`--detach`) and the default PostgreSQL port 5432 will be
#' published to `localhost:5432`.
#' @param container_name character: a valid container name for the container
#' @param image_tag character: a valid image tag (name) for the docker image to
#' run. Default is the base PostgreSQL 10 image, `docker.io/postgres:10`.
#' @param postgres_password character: the `postgres` database superuser
#' password. Default is "postgres".
#' @return Result of Docker command if it succeeded. Stops with an error message
#' if it failed.
#' @importFrom glue glue
#' @export sp_pg_docker_run
#' @examples
#' \dontrun{
#' build_log <- sp_make_dvdrental_image("test-dvdrental:latest")
#' sp_docker_images_tibble()
#' sp_pg_docker_run("test-dvdrental", "test-dvdrental:latest")
#' sp_docker_containers_tibble()
#' }

sp_pg_docker_run <- function(container_name,
                             image_tag = "docker.io/postgres:10",
                             postgres_password = "postgres") {
  run_options <- glue::glue(
    "--detach ", # run in the backgrouns
    "--name ", container_name, " ", # gives the container a name
    "--publish 5432:5432 ", # publish the default Postgres port
    "--env POSTGRES_PASSWORD=", postgres_password # database superuser password
  )
  result <- sp_docker_run(image_tag = image_tag, options = run_options)
}

#' @title Make simple PostgreSQL container
#' @name sp_make_simple_pg
#' @description Creates a container and runs the PostgreSQL 10 image
#' (`docker.io/postgres:10`) in it. The image will be downloaded if it doesn't
#' exist locally.
#' @param container_name character: a valid container name for the
#' container
#' @param postgres_password character: superuser password. Default is
#' "postgres".
#' @return Result of Docker command if it succeeded. Stops with an
#' error message if it failed.
#' @export sp_make_simple_pg
#' @examples
#' \dontrun{
#' run_log <- sp_make_simple_pg("livestock")
#' sp_docker_images_tibble()
#' sp_docker_containers_tibble()
#' }

sp_make_simple_pg <- function(container_name,
                              postgres_password = "postgres") {
  result <- sp_pg_docker_run(container_name,
                             image_tag = "docker.io/postgres:10",
                             postgres_password = postgres_password)
}

#' @title List containers into a tibble
#' @name sp_docker_containers_tibble
#' @description Creates a tibble of containers using `docker ps`
#' @param list_all logical: list all containers if `TRUE`, just
#' *running* containers if `FALSE`. Default is `FALSE`.
#' @return A tibble listing the containers. If there are none,
#' returns an empty (0x0) tibble.
#' @importFrom readr read_delim
#' @importFrom readr cols
#' @importFrom readr col_character
#' @importFrom dplyr %>%
#' @importFrom snakecase to_snake_case
#' @importFrom tibble tibble
#' @export sp_docker_containers_tibble
#' @examples
#' \dontrun{
#' sp_docker_containers_tibble(list_all = FALSE)
#' }

sp_docker_containers_tibble <- function(list_all = FALSE) {

  # everything Docker knows about a container - see
  # https://docs.docker.com/engine/reference/commandline/ps/#formatting
  prettyprint_format <- paste(
    "table {{.ID}}",
    "{{.Image}}",
    "{{.Command}}",
    "{{.CreatedAt}}",
    "{{.RunningFor}}",
    "{{.Ports}}",
    "{{.Status}}",
    "{{.Size}}",
    "{{.Names}}",
    "{{.Labels}}",
    "{{.Mounts}}",
    "{{.Networks}}",
    sep = "|"
  )
  all_flag <- ifelse(list_all, "--all ", "")
  docker_cmd <- paste(
    "ps ", all_flag, "--format ",
    '"',
    prettyprint_format,
    '"',
    sep = ""
  )
  listing <- system2(
    "docker", docker_cmd, stdout = TRUE, stderr = FALSE
  )

  # are there any data rows?
  if (length(listing) > 1) {
    containers <- listing %>%
      readr::read_delim(
        delim = "|",
        col_types = readr::cols(.default = readr::col_character())
      )
    colnames(containers) <- colnames(containers) %>%
      snakecase::to_snake_case()
    return(containers)
  }

  # no containers - return an empty tibble
  return(tibble::tibble())
}

#' @title List images into a tibble
#' @name sp_docker_images_tibble
#' @description Creates a tibble of images using `docker images`
#' @param list_all logical: list all images if `TRUE`, just
#' *tagged* images if `FALSE`. Default is `FALSE`.
#' @return A tibble listing the images
#' @importFrom readr read_delim
#' @importFrom readr cols
#' @importFrom readr col_character
#' @importFrom dplyr %>%
#' @importFrom snakecase to_snake_case
#' @importFrom tibble tibble
#' @export sp_docker_images_tibble
#' @examples
#' \dontrun{
#' sp_docker_images_tibble(list_all = FALSE)
#' }

sp_docker_images_tibble <- function(list_all = FALSE) {

  # everything Docker knows about an image - see
  # https://docs.docker.com/engine/reference/commandline/images/#format-the-output
  prettyprint_format <- paste(
    "table {{.ID}}",
    "{{.Repository}}",
    "{{.Tag}}",
    "{{.Digest}}",
    "{{.CreatedSince}}",
    "{{.CreatedAt}}",
    "{{.Size}}",
    sep = "|"
  )
  all_flag <- ifelse(list_all, "--all ", "")
  docker_cmd <- paste(
    "images ", all_flag, "--format ",
    '"',
    prettyprint_format,
    '"',
    sep = ""
  )
  listing <- system2(
    "docker", docker_cmd, stdout = TRUE, stderr = FALSE
  )

  # are there any data rows?
  if (length(listing) > 1) {
    images <- listing %>%
      readr::read_delim(
        delim = "|",
        col_types = readr::cols(.default = readr::col_character())
      )
    colnames(images) <- colnames(images) %>%
      snakecase::to_snake_case()
    return(images)
  }

  # no images - return an empty tibble
  return(tibble::tibble())
}

#' @title Forcibly remove a container
#' @name sp_docker_remove_container
#' @description Forcibly removes a Docker container. If it is running it will be
#' forcibly terminated and removed. If it doesn't exist you won't get an error
#' message. This is a blunt instrument!
#' @param docker_container character: the name of the container to
#' remove
#' @return a numeric `0`
#' @examples
#' \dontrun{sp_docker_remove_container("sql-pet")}
#' @details Warning: this function removes the container you asked it to remove!
#' @export sp_docker_remove_container

sp_docker_remove_container <- function(docker_container) {
  docker_command <- paste0("rm --force ", docker_container)
  result <- system2(
    "docker", docker_command, stdout = FALSE, stderr = FALSE
  )
  return(0)
}

#' @title Forcibly remove an image
#' @name sp_docker_remove_image
#' @description Forcibly removes a Docker image. If it doesn't exist you won't
#'  get an error message. This is a blunt instrument!
#' @param docker_image character: the name of the image to remove
#' @return a numeric `0`
#' @examples
#' \dontrun{sp_docker_remove_image("docker.io/postgres:10")}
#' @details Warning: this function removes the image you asked it to remove!
#' @export sp_docker_remove_image

sp_docker_remove_image <- function(docker_image) {
  docker_command <- paste0("rmi --force ", docker_image)
  result <- system2(
    "docker", docker_command, stdout = FALSE, stderr = FALSE
  )
  return(0)
}

#' @title Start an existing container
#' @name sp_docker_start
#' @description Starts the container given by `container_name`.
#' @param container_name character: container to start
#' @return Result of Docker command if it succeeded. Stops with an
#' error message if it failed.
#' @importFrom glue glue
#' @export sp_docker_start
#' @examples
#' \dontrun{sp_docker_start("sql-pet")}
sp_docker_start <- function(container_name) {
  docker_cmd <- glue::glue(
    "start ", # Docker command.
    container_name # gives the container a name
  )
  result <- .system2_to_docker(docker_cmd)
}

#' @title Stop an existing container
#' @name sp_docker_stop
#' @description Stops the container given by `container_name`.
#' @param container_name character: container to stop
#' @return Result of Docker command if it succeeded. Stops with an
#' error message if it failed.
#' @importFrom glue glue
#' @export sp_docker_stop
#' @examples
#' \dontrun{sp_docker_stop("sql-pet")}
sp_docker_stop <- function(container_name) {
  docker_cmd <- glue::glue(
    "stop ", # Docker command.
    container_name # gives the container a name
  )
  result <- .system2_to_docker(docker_cmd)
}

utils::globalVariables(c(
  "docker_cmd"
))
