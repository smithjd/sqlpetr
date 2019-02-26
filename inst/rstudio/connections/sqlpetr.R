library(sqlpetr)
# fill in the parameters, test, then "OK" to deploy connection
connection <- sp_get_postgres_connection(
  user, password, dbname, host, port, seconds_to_test
)
