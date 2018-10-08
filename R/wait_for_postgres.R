library(RPostgres)
library(DBI)

#' Connect to Postgres, waiting if it is not ready
#'
#' Assumptions: host = "localhost" and port = "5432".
#' @param user Username for connecting to the database
#' @param password Password that corresponds to the username
#' @param dbname the name of the database within the database server
#' @param seconds_to_test the number of iterations to try while waiting for PostgreSQL service to be ready.
#' @return When successful: a connection object, which is an S4 object that inherits from DBIConnection used to communicate with the database engine; Otherwise, an error string.
#' @export
wait_for_postgres <-
  function(user, password, dbname, seconds_to_test = 10) {
    conn <- NULL
    db_ready <- FALSE
    for (i in 1:abs(seconds_to_test)) {
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
    }
    if (!db_ready) {
      conn <- "There is no connection"
    }
    conn
  }
