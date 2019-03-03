library(sqlpetr)
# fill in the parameters, test, then "OK" to deploy connection
connection <- sp_get_postgres_connection(
  user, password, dbname,
  host = "localhost", port = 5432, seconds_to_test = 30,
  connection_tab = FALSE
)
