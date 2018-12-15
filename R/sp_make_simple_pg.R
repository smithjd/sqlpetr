#' Define and run a Docker container with PostgreSQL in it
#'
#' @param container_name name for the docker container
#'
#' @return 0
#' @importFrom glue glue
#' @export
#'
#' @examples sp_make_simple_pg("cattle")
sp_make_simple_pg <- function(container_name) {
  docker_cmd <- glue::glue(
    "run ", # Run is the Docker command.  Docker run parameters follow
    "--detach ", # disconnect from the terminal / program issuing the command
    "--name ", container_name, # gives the container a name
    " --publish 5432:5432 ", # Exposes the default Postgres port
    " postgres:10 "  # Docker the image to be run (after downloading if necessary)
  )
  result <- system2("docker", docker_cmd, stdout = TRUE, stderr = TRUE)
  status <- attr(result, "status")
  if (length(status) > 0) {
    print(paste("command:", docker_cmd))
    print(paste("return:", result))
    stop(paste("Docker command failed with status", status))
  }
  return(0)
}
