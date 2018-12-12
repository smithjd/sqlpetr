#' Check that docker is running
#'
#' @return 0
#' @export
#'
#' @examples sp_show_all_docker_containers()
sp_show_all_docker_containers <- function() {
  response <- system2("docker", "ps -a ",
                      stdout = TRUE, stderr = FALSE)
  response_length <- length(response)
  if (response_length == 1) {
    stop("There are no Docker containers running")
  }
  cat(response, sep = "\n")
}
