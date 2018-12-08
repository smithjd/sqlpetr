#' Removes the specified docker container
#'
#' @param docker_container is the name of the docker container to remove.
#'
#' @return 0
#' @details `sp_docker_remove_container` will forcibly remove the specified
#' container. If it did not exist, no errors or warnings will be given.
#'
#' @examples sp_docker_remove_container("sql-pet")
#'
#' @export
sp_docker_remove_container <- function(docker_container) {
  docker_command <- paste0("rm -f ", docker_container)
  result <- system2("docker", docker_command, stdout = TRUE, stderr = TRUE)
  return(0)
}
