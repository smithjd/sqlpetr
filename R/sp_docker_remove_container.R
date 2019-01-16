#' @title Forcibly remove a container
#' @name sp_docker_remove_container
#' @description Forcibly removes a Docker container. If it is
#' running it will be forcibly terminated and removed. If it
#' doesn't exist you won't get an error message. This is a blunt
#' instrument!
#' @param docker_container character the name of the container to
#' remove
#' @return a numeric `0`
#' @examples
#' \dontrun{sp_docker_remove_container("sql-pet")}
#' @details Warning: this function removes the container you asked
#' it to remove!
#' @export sp_docker_remove_container

sp_docker_remove_container <- function(docker_container) {
  docker_command <- paste0("rm -f ", docker_container)
  result <- system2(
    "docker", docker_command, stdout = FALSE, stderr = FALSE
  )
  return(0)
}
