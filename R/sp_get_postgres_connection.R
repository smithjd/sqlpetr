library(RPostgres)
library(DBI)

#' Connect to a PostgreSQL database, waiting if it is not ready
#'
#' This function is used during development to connect to an instance of PostgreSQL that is running on the developer's local machine, such as in a Docker container.
#'    Assumptions: host = "localhost" and port = "5432".
#' @param user Username for connecting to the database
#' @param password Password that corresponds to the username
#' @param dbname the name of the database within the database server
#' @param seconds_to_test the number of iterations to try while waiting for PostgreSQL service to be ready.
#' @return When successful: a connection object, which is an S4 object that inherits from DBIConnection used to communicate with the database engine; Otherwise, an error string.
#' @export
sp_get_postgres_connection <-
  function(user, password, dbname, seconds_to_test = 10) {
    conn <- NULL
    db_ready <- FALSE
    n_iterations <- abs(seconds_to_test)
    i <- 1
    while (i <= n_iterations & is.null(conn)) {
      db_ready <- DBI::dbCanConnect(
        RPostgres::Postgres(),
        host = "localhost",
        port = "5432",
        user = user,
        password = password,
        dbname = dbname
      )
      if (!db_ready) {
        Sys.sleep(1)
      }
      else {
        conn <- DBI::dbConnect(
          RPostgres::Postgres(),
          host = "localhost",
          port = "5432",
          user = user,
          password = password,
          dbname = dbname
        )
      }
      i <- i + 1
    }
    if (is.null(conn)) {
      conn <- "There is no connection"
    }
    conn
  }
