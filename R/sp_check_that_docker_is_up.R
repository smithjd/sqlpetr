#' Check that docker is running
#'
#' @return 0
#' @importFrom stringr str_detect
#' @export
#'
#' @examples sp_check_that_docker_is_up()
sp_check_that_docker_is_up <- function() {
  response <- system2("docker", "ps ", stdout = TRUE, stderr = TRUE)
  if (length(response) == 1) {
    message <- ifelse(str_detect(response[[1]],"CONTAINER.+CREATED.+NAMES"),
           "Docker is up but running no containers",
           response[[1]])
  } else {
    message <- c("Docker is up, running these containers:", response)
  }
  message
}
