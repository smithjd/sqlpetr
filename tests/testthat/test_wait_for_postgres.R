
context("Trying to connect to a PostgreSQL instance")

test_that("Error message when unable to connect", {
  conn <- wait_for_postgres(
    "unknown_user",
    "some_password",
    "unknown_database",
    -2
  )
  expect_equal(conn, "There is no connection")
})
