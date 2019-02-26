library(sqlpetr)
connection <- sp_get_postgres_connection(
  user = ${0:user="postgres"},
  password = ${1:password=""},
  dbname = ${2:dbname=""},
  host = ${3:host="localhost"},
  port = ${4:port=5432},
  seconds_to_test = ${5:seconds_to_test=30})
