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
#' @param connection_tab logical: `sp_get_postgres_connection` can open a
#' tab in the RStudio connections pane. `connection_tab = FALSE` is
#' the default - call with `connection_tab = TRUE` to open the tab.
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
#' \dontrun{
#' build_log <- sp_make_dvdrental_image("test-dvdrental:latest")
#' sp_docker_images_tibble()
#' sp_pg_docker_run(
#'   container_name = "test-dvdrental",
#'   image_tag = "test-dvdrental:latest",
#'   postgres_password = "postgres"
#' )
#' sp_docker_containers_tibble()
#' connection <- sp_get_postgres_connection(
#'   user = "postgres",
#'   password = "postgres",
#'   dbname = "dvdrental",
#'   host = "localhost",
#'   port = 5432,
#'   seconds_to_test = 30,
#'   connection_tab = TRUE
#' )
#' }

sp_get_postgres_connection <- function(user, password, dbname,
                                       host = "localhost",
                                       port = "5432",
                                       seconds_to_test = 30,
                                       connection_tab = FALSE) {

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

      # open a connection tab if wanted!
      if (connection_tab) {
        .sp_pg_connection_opened(conn)
      }

      return(conn)
    }

    # database isn't ready - sleep and retry
    Sys.sleep(1)
  }

  # couldn't connect - throw an error
  stop(paste("Database is not ready - reason:", attr(db_ready, "reason")))
}

#' @title Fetch a PostgreSQL database catalog
#' @name sp_pg_catalog
#' @description PostgreSQL stores much of its metadata in system catalogs that
#' are accessible to a connected user. This function takes a connection and
#' returns the database catalog as a data frame.
#' @param connection A valid open `DBI` connection to a PostgreSQL database.
#' @return A data frame with the contents of the database catalog. The columns
#' are `schemas`, `name`, and `type`, where `type` is "matview" (materialized
#' view), "view" or "table".
#' @importFrom DBI dbReadTable
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr bind_rows
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
#' print(sp_pg_catalog(connection))
#' }

sp_pg_catalog <- function(connection) {

  # get the raw data
  matviews <- DBI::dbReadTable(connection, "pg_matviews") %>% dplyr::filter(
    schemaname != "pg_catalog", schemaname != "information_schema") %>%
    dplyr::select(schemas = schemaname, name = matviewname) %>%
    dplyr::mutate(type = "matview")
  views <- DBI::dbReadTable(connection, "pg_views") %>%  dplyr::filter(
    schemaname != "pg_catalog", schemaname != "information_schema") %>%
    dplyr::select(schemas = schemaname, name = viewname) %>%
    dplyr::mutate(type = "view")
  tables <- DBI::dbReadTable(connection, "pg_tables") %>% dplyr::filter(
    schemaname != "pg_catalog", schemaname != "information_schema") %>%
    dplyr::select(schemas = schemaname, name = tablename) %>%
    dplyr::mutate(type = "table")
  return(as.data.frame(
    dplyr::bind_rows(matviews, views, tables), stringAsFactors = FALSE))
}

# Functions for the Connection Contract
# See https://rstudio.github.io/rstudio-extensions/connections-contract.html
# and https://github.com/r-dbi/odbc/blob/master/R/Viewer.R

# `sp_pg_list_object_types` displays the data object hierarchy. This is the
# same as the `odbc` package would have for PostgreSQL, but they don't know
# about materialized views (matviews). I should file an issue - I think I can
# patch it.
.sp_pg_list_object_types <- function(connection) {
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

#' @importFrom dplyr %>%
#' @importFrom dplyr select
#' @importFrom dplyr mutate
.sp_pg_list_objects <- function(
  connection,
  catalog = NULL, schema = NULL, name = NULL, type = NULL, ...) {

  database_structure <- sp_pg_catalog(connection)
  save(catalog, schema, name, type, file = "~/list_objects.Rdata")

  # schema is NULL - return list of schemas
  if (is.null(schema)) {
    schemas <- database_structure %>% dplyr::select(name = schemas) %>%
      unique() %>% dplyr::mutate(type = "schema")
    save(schemas, file = "~/schemas.Rdata")
    return(as.data.frame(schemas, stringsAsFactors = FALSE))
  } else {
    return(subset(
      database_structure, select = name:type, subset = schemas == schema))
  }
}

#' @importFrom DBI dbSendQuery
#' @importFrom DBI dbColumnInfo
#' @importFrom DBI dbClearResult
.sp_pg_list_columns <- function(
  connection,
  table = NULL, view = NULL, matview = NULL, catalog = NULL, schema = NULL, ...) {

  # get item name
  if (!is.null(table)) {
    item <- table
  } else if (!is.null(view)) {
    item <- view
  } else if (!is.null(matview)) {
    item <- matview
  } else {
    stop("at least one data item - table, view or matview - must be specified")
  }
  item <- ifelse(is.null(schema), item, sprintf("%s.%s", schema, item))

  # fetch the column info
  rs <- DBI::dbSendQuery(connection, sprintf("SELECT * FROM %s LIMIT 1", item))
  columns <- DBI::dbColumnInfo(rs) %>%
    dplyr::select(name, type) %>% as.data.frame()
  DBI::dbClearResult(rs)
  return(columns)
}

#' @importFrom DBI dbGetQuery
.sp_pg_preview_object <- function(
  connection, rowLimit,
  table = NULL, view = NULL, matview = NULL, schema = NULL, catalog = NULL, ...) {

  # get item name
  if (!is.null(table)) {
    item <- table
  } else if (!is.null(view)) {
    item <- view
  } else if (!is.null(matview)) {
    item <- matview
  } else {
    stop("at least one data item - table, view or matview - must be specified")
  }
  item <- ifelse(is.null(schema), item, sprintf("%s.%s", schema, item))

  return(DBI::dbGetQuery(
    connection, sprintf("SELECT * FROM %s", item), n = min(100, rowLimit)
  ))
}

#' @importFrom DBI dbGetInfo
.sp_pg_display_name <- function(connection) {
  db_info <- DBI::dbGetInfo(connection)
  return(sprintf(
    "%s - %s@%s",
    db_info[["dbname"]], db_info[["user"]], db_info[["host"]]))
}

#' @importFrom DBI dbGetInfo
.sp_pg_host_name <- function(connection) {
  db_info <- DBI::dbGetInfo(connection)
  return(sprintf(
    "%s_%s_%s",
    db_info[["dbname"]], db_info[["user"]], db_info[["host"]]))
}

#' @importFrom utils browseURL
.sp_pg_actions_list <- function() {
  actions <- list(
    Help = list(
      icon = system.file("icons/help.png", package = "sqlpetr"),
      callback = function() {
        utils::browseURL("https://smithjd.github.io/sqlpetr")
      }
    )
  )
}

.sp_pg_connection_code_string <- function() {
  paste(
    "library(sqlpetr)",
    "# fill in the parameters, test, then 'OK' to deploy connection",
    "connection <- sp_get_postgres_connection(",
    "user, password, dbname,",
    "host = 'localhost', port = 5432, seconds_to_test = 30,",
    "connection_tab = FALSE",
    ")",
    sep = "\n"
  )
}

.sp_pg_connection_opened <- function(connection) {

  # get the observer with silent return if there isn't one
  observer <- getOption("connectionObserver")
  if (is.null(observer)) {
    return(invisible(NULL))
  }

  # call the observer
  observer$connectionOpened(
    type = "PostgreSQL",
    displayName = .sp_pg_display_name(connection),
    host = .sp_pg_host_name(connection),
    icon = system.file("icons/postgresql.png", package = "sqlpetr"),
    connectCode = .sp_pg_connection_code_string(),
    disconnect = function() {sp_pg_close_connection(connection)},
    listObjectTypes = function () {.sp_pg_list_object_types()},
    listObjects = function(...) {.sp_pg_list_objects(connection, ...)},
    listColumns = function(...) {.sp_pg_list_columns(connection, ...)},
    previewObject = function(rowLimit, ...) {
      .sp_pg_preview_object(connection, rowLimit, ...)
    },
    actions = .sp_pg_actions_list(),
    connectionObject = connection
  )
}

#' @title Notify observer and close connection
#' @name sp_pg_close_connection
#' @description Tells the connections tab observer that connection was closed
#' and then closes it
#' @param connection A valid open connection from `sp_get_postgres_connection`.
#' @return not meaningful
#' @importFrom DBI dbDisconnect
#' @export sp_pg_close_connection
sp_pg_close_connection <- function(connection) {

  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
    observer$connectionClosed(
      type = "PostgreSQL",
      host = .sp_pg_host_name(connection)
    )
  }
  DBI::dbDisconnect(connection)

}

utils::globalVariables(c(
  "matviewname",
  "name",
  "schemaname",
  "tablename",
  "type",
  "viewname"
))
