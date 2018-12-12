#' Start the specified docker container
#'
#' @param docker_container is the name of the docker container to start up.
#'
#' @return 0
#' @export
#'
#' @examples sp_docker_start("sql-pet")
sp_docker_start <- function(docker_container) {
  docker_command <- paste0("start ", docker_container)
  response <- system2("docker", docker_command)
}
