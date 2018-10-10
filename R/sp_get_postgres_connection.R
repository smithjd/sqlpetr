#' Get a DBI connection string to a PostgreSQL database, waiting if it is not ready
#'
#' This function connects to an instance of PostgreSQL.
#'
#' @param user Username for connecting to the database
#' @param password Password that corresponds to the username
#' @param dbname The name of the database within the database server
#' @param seconds_to_test The number of iterations to try while waiting for PostgreSQL service to be ready.
#' @param host The IP address or host where postgreSQL is located, defaults to "localhost"
#' @param port The port on the host that postgreSQL listens to, defaults to "5432"
#'
#' @return When successful: a connection object, which is an S4 object that inherits from DBIConnection used to communicate with the database engine; Otherwise, an error string.
#'
#' @examples con <- sp_get_postgres_connection("postgres", "postgres")
#'
#' @export
sp_get_postgres_connection <- function(user, password, dbname,
           host = "localhost",
           port = "5432",
           seconds_to_test = 10) {
    conn <- NULL
    db_ready <- FALSE
    n_iterations <- abs(seconds_to_test)
    i <- 1
    while (i <= n_iterations & is.null(conn)) {
      db_ready <- DBI::dbCanConnect(
        RPostgres::Postgres(),
        host = host,
        port = port,
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
          host = host,
          port = port,
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
