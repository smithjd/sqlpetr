# local function to call to Docker via system2
.system2_to_docker <- function(docker_command_string) {

  # pass the command to Docker via `system2` and capture the
  # outputs
  result <- system2(
    "docker", docker_cmd, stdout = TRUE, stderr = TRUE
  )
  status <- attr(result, "status")

  # abort with the error message if the command failed
  if (length(status) > 0) {
    message(paste("command:", docker_cmd))
    message(paste("return:", result))
    stop(paste("Docker command failed with status", status))
  }

  # it worked - return the result
  return(result)
}

#' @title Make `dvdrental` Docker image
#' @name sp_make_dvdrental_image
#' @description Creates a Docker image with PostgreSQL and the
#' `dvdrental` database
#' @param image_tag character a valid image tag (name) for the
#'  docker image
#' @return Result of Docker command if it succeeded. Stops with an
#'  error message if it failed.
#' @importFrom glue glue
#' @export sp_make_dvdrental_image
#' @examples
#' \dontrun{sp_make_dvdrental_image("dvdrental")}
#' @details See the vignette "Building the `dvdrental` Docker Image" for the details.

sp_make_dvdrental_image <- function(image_tag) {

  # path to Docker build context
  build_context <- paste(
    system.file(package = "sqlpetr"),
    "/extdata/docker", sep = "/"
  )
  docker_cmd <- glue::glue(
    "build ", # docker build
    "--tag ", image_tag, " ", # gives the image a name
    build_context
  )
  result <- .system2_to_docker(docker_cmd)
}

#' @title Run a PostgreSQL Docker image in a container
#' @name sp_pg_docker_run
#' @description Creates a container and runs an image in it. The image should be based on the `postgres:10` image
#' @param image_tag character a valid image tag (name) for the
#' docker image. If it doesn't exist locally, `docker run` will
#' try to download it. If the download fails, the function will
#' abort.
#' @param container_name character a valid container name for the
#' container
#' @return Result of Docker command if it succeeded. Stops with an
#' error message if it failed.
#' @importFrom glue glue
#' @export sp_pg_docker_run
#' @examples
#' \dontrun{
#' sp_make_dvdrental_image("dvdrental:latest")
#' sp_pg_docker_run("dvdrental:latest", "sql-pet")
#' }

sp_pg_docker_run <- function(image_tag, container_name) {
  docker_cmd <- glue::glue(
    "run ", # Run is the Docker command.
    "--detach ", # run in the backgrouns
    "--name ", container_name, # gives the container a name
    " --publish 5432:5432 ", # Exposes the default Postgres port
    image_tag # Docker the image to be run
  )
  result <- .system2_to_docker(docker_cmd)
}

#' @title Make simple PostgreSQL container
#' @name sp_make_simple_pg
#' @description Creates a container and runs the PostgreSQL 10
#' image (`postgres:10`) in it. The image will be downloaded if
#' it doesn't exist locally.
#' @param container_name character a valid container name for the
#' container
#' @return Result of Docker command if it succeeded. Stops with an
#'  error message if it failed.
#' @export sp_make_simple_pg
#' @examples
#' \dontrun{
#' sp_make_simple_pg("cattle")
#' }

sp_make_simple_pg <- function(container_name) {
  result <- sp_pg_docker_run("postgres:10")
}
