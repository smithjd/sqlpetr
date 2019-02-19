#' @title Connect to a PostgreSQL database
#' @name sp_get_postgres_connection
#' @description Attempts to connect to a PostgreSQL database. If the connection
#' fails, it will retry a user-specified number of times.
#' @param user character: Username for connecting to the database. There is no
#' default. The user must exist and be authorized to connect.
#' @param password character: Password that corresponds to the username. There
#' is no default. The password must be correct for the user.
#' @param dbname character: The name of the database within the database server.
#' The database must exist, and the user must be authorized to access it.
#' @param host character: The IP address or host where postgreSQL is located,
#' defaults to "localhost"
#' @param port integer: The port on the host that postgreSQL listens to, defaults
#' to "5432"
#' @param seconds_to_test integer: The number of iterations to try while waiting
#' for PostgreSQL service to be ready. The function sleeps one second between
#' connection attempts, so a value of 10 would require approximately 10 seconds.
#' The default is 30.
#' @return If successful: a connection object, which is an S4 object
#' that inherits from DBIConnection, used to communicate with the
#' database engine. If unsuccessful, the function terminates with an
#' error message.
#' @importFrom DBI dbCanConnect
#' @importFrom RPostgres Postgres
#' @export sp_get_postgres_connection
#' @examples
#' \dontrun{con <- sp_get_postgres_connection(
#'   user = "postgres",
#'   password = "postgres",
#'   dbname = "postgres"
#' )}

sp_get_postgres_connection <- function(user, password, dbname,
                                       host = "localhost",
                                       port = "5432",
                                       seconds_to_test = 30) {

  n_iterations <- abs(seconds_to_test)
  for (iter in 1:n_iterations) {
    db_ready <- DBI::dbCanConnect(
      RPostgres::Postgres(),
      host = host,
      port = port,
      user = user,
      password = password,
      dbname = dbname
    )

    # return a connection if it worked
    if (db_ready) {
      conn <- DBI::dbConnect(
        RPostgres::Postgres(),
        host = host,
        port = port,
        user = user,
        password = password,
        dbname = dbname
      )
      return(conn)
    }

    # database isn't ready - sleep and retry
    Sys.sleep(1)
  }

  # couldn't connect - throw an error
  stop(paste("Database is not ready - reason:", attr(db_ready, "reason")))
}

#' @title List databases in a PostgreSQL cluster
#' @name sp_pg_databases
#' @description Connects to a PostgreSQL server and delivers a tibble with the
#' names of the databases in the cluster the server is hosting
#' @param connection A valid open connection to the server
#' @return A tibble listing all the databases in the cluster. This is simply
#' the PostgreSQL catalog `pg_database`. See
#' <https://www.postgresql.org/docs/10/catalog-pg-database.html>
#' for the documentation of the columns. `datname` is the database name, which
#' is probably all you want.
#' @importFrom DBI dbReadTable
#' @importFrom tibble as_tibble
#' @export sp_pg_databases
#' @examples
#' \dontrun{connection <- sp_get_postgres_connection(
#'   user = "postgres",
#'   password = "postgres",
#'   dbname = "postgres"
#' )
#' databases <- sp_pg_databases(connection)
#' print(databases)
#'
#' }

sp_pg_databases <- function(connection) {
  return(tibble::as_tibble(DBI::dbReadTable(connection, "pg_database")))
}
