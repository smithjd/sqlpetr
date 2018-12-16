#' Stops the specified docker container
#'
#' @param docker_container is the name of the docker container to start up.
#'
#' @return 0
#' @export
#'
#' @examples
#' \dontrun{sp_docker_stop("sql-pet")}
sp_docker_stop <- function(docker_container) {
  docker_command <- paste0("stop ", docker_container)
  system2("docker", docker_command)
}
