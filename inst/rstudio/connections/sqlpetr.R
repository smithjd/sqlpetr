library(sqlpetr)
connection <- sp_get_postgres_connection(
  user, password, dbname, host, port, seconds_to_test
)
