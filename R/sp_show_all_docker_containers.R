#' Check that docker is running
#'
#' @return 0
#' @export
#'
#' @examples sp_show_all_docker_containers()
sp_show_all_docker_containers <- function() {
  response <- system2("docker", "ps -a",
                      stdout = TRUE, stderr = TRUE)
  response
}
