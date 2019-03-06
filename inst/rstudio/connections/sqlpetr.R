library(sqlpetr)
# defaults for the "sql-pet" container with "dvdrental" database
# change the parameter values for your own database configuration
connection <- sp_get_postgres_connection(
  user = "postgres",
  password = "postgres",
  dbname = "dvdrental",
  host = "localhost",
  port = 5432,
  seconds_to_test = 30,
  connection_tab = TRUE
)
