#' Create an image with PostgreSQL and the `dvdrental` database
#'
#' @param image_name name for the docker image
#'
#' @return Result of Docker command if it succeeded. Stops with an error message
#' if it failed.
#' @importFrom glue glue
#' @export
#'
#' @examples
#' \dontrun{sp_make_dvdrental_image("dvdrental")}
#' @details
#' This function executes a `docker build` with build context of this
#' package's `extdata/docker` directory. In RStudio package development,
#' it's `inst/extdata/docker`.
#'
#' The Dockerfile fetches the PostgreSQL 10 image, then installs `unzip`. It then
#' downloads and unzips the DVD rental database. Then it copyies a restore
#' script into the container's directory `/docker-entrypoint-initdb.d/restoredb.sh`.
#'
#' This script will run when a container first runs the image. It simply creates
#' the `dvdrental` database and restores the unzipped `tar` archive to it with
#' `pg_restore`.

sp_make_dvdrental_image <- function(image_name) {
  docker_cmd <- glue::glue(
    "build ", # docker build
    "--tag ", image_name, " ", # gives the image a name
    system.file(package = "sqlpetr"), "/extdata/docker"  # path to Docker build context
  )
  result <- system2("docker", docker_cmd, stdout = TRUE, stderr = TRUE)
  status <- attr(result, "status")
  if (length(status) > 0) {
    message(paste("command:", docker_cmd))
    message(paste("return:", result))
    stop(paste("Docker command failed with status", status))
  }
  return(result)
}
