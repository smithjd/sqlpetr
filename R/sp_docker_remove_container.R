#' Removes the specified docker container
#'
#' @param docker_container is the name of the docker container to remove.
#'
#' @return 0
#' @export
#'
#' @examples sp_docker_remove_container("sql-pet")
sp_docker_remove_container <- function(docker_container) {
  docker_command <- paste0("rm -f ", docker_container)
  system2("docker", docker_command, stdout = TRUE, stderr = TRUE)
}
