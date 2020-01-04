con <- dbConnect(
  odbc::odbc(),
  .connection_string =
    "Driver={ODBC Driver 17 for SQL Server};Server=localhost;Database=AdventureWorks2017;UID=SA;PWD=sit-d0wn-COMIC",
  timeout = 10
)
