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
