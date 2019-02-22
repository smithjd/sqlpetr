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

#' @title Fetch a PostgreSQL system catalog
#' @name sp_pg_catalog
#' @description PostgreSQL stores much of its metadata in system catalogs that
#' are accessible to a connected user. This function takes a connection and
#' a catalog name and returns the catalog as a tibble.
#' @param connection A valid open `DBI` connection to a PostgreSQL database.
#' @param catalog_name character: the name of the catalog to fetch. See
#' <https://www.postgresql.org/docs/10/catalogs.html>
#' for documentation of the system catalogs. The example lists some useful
#' catalogs for the `dvdrental` database.
#' @return A tibble with the contents of the catalog
#' @importFrom DBI dbReadTable
#' @importFrom tibble as_tibble
#' @export sp_pg_catalog
#' @examples
#' \dontrun{
#' library(sqlpetr)
#' library(dplyr)
#' connection <- sp_get_postgres_connection(
#'   user = "postgres",
#'   password = "postgres",
#'   dbname = "dvdrental"
#' )
#' databases <- sp_pg_catalog(connection, "pg_database")
#' print(databases)
#' matviews <- sp_pg_catalog(connection, "pg_matviews") %>%
#'   dplyr::filter(schemaname != "pg_catalog", schemaname != "information_schema")
#' print(matviews)
#' views <- sp_pg_catalog(connection, "pg_views") %>%
#'   dplyr::filter(schemaname != "pg_catalog", schemaname != "information_schema")
#' print(views)
#' tables <- sp_pg_catalog(connection, "pg_tables") %>%
#'   dplyr::filter(schemaname != "pg_catalog", schemaname != "information_schema")
#' print(tables)
#' }
#' @details You probably only want lists of user-level tables, views and
#' materialized views. The `dplyr::filter` invocation in the examples shows how
#' to do this.

sp_pg_catalog <- function(connection, catalog_name) {
  return(tibble::as_tibble(DBI::dbReadTable(connection, catalog_name)))
}

# Function for the Connection Contract
# See https://rstudio.github.io/rstudio-extensions/connections-contract.html
# and https://github.com/r-dbi/odbc/blob/master/R/Viewer.R
#
# Package `odbc` exports some of the functions we need. The rest we copy and
# paste.

# displays the data object hierarchy. This is the same as the `odbc` package
# would have for PostgreSQL, but they don't know about materialized views
# (matviews). I should file an issue - I think I can patch it.
.sp_pg_list_object_types <- function() {
  list(
    schema = list(
      contains = list(
        table = list(
          contains = "data"),
        matview = list(
          contains = "data"),
        view = list(
          contains = "data")
      )
    )
  )
}

.sp_pg_list_objects <- function(connection, ...) {
  odbc::odbcListObjects(connection, ...)
}

.sp_pg_list_columns <- function(connection, ...) {
  odbc::odbcListColumns(connection, ...)
}

sp_pg_preview_object <- function(connection, rowLimit, ...) {
  odbc::odbcPreviewObject(connection, rowLimit, ...)
}
