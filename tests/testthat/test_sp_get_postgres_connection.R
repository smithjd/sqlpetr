
context("Connecting to a PostgreSQL instance")

EXPECTED_ERROR_MESSAGE = "There is no connection"

test_that("Expects error message when unable to connect", {
  conn <- sp_get_postgres_connection(
    user = "unknown_user",
    password = "some_password",
    dbname = "unknown_database",
    seconds_to_test = 3
  )
  expect_equal(conn, EXPECTED_ERROR_MESSAGE)
})

test_that("Expects negative 'seconds_to_test' is ignored", {
  conn <- sp_get_postgres_connection(
    user = "unknown_user",
    password = "some_password",
    dbname = "unknown_database",
    seconds_to_test = -1
  )
  expect_equal(conn, EXPECTED_ERROR_MESSAGE)
})

test_that("Handles 0 seconds_to_test", {
  conn <- sp_get_postgres_connection(
    user = "unknown_user",
    password = "some_password",
    dbname = "unknown_database",
    seconds_to_test = 0
  )
  expect_equal(conn, EXPECTED_ERROR_MESSAGE)
})
