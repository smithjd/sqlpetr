
context("Build, run and test the 'DVD Rental' container")

test_that("dvd_rental_runs", {

  # define constants
  image_tag <- "test-dvdrental:latest"
  container_name <- "test-dvdrental"
  postgres_user = "postgres"
  postgres_password = "charlie_h0rse"
  table_list <- c(
    "actor_info",
    "customer_list",
    "film_list",
    "nicer_but_slower_film_list",
    "sales_by_film_category",
    "staff",
    "sales_by_store",
    "staff_list",
    "category",
    "film_category",
    "country",
    "actor",
    "language",
    "inventory",
    "payment",
    "rental",
    "city",
    "store",
    "film",
    "address",
    "film_actor",
    "customer"
  )

  # force remove container and image
  sp_docker_remove_container(container_name)
  sp_docker_remove_image(image_tag)

  # build the image
  sp_make_dvdrental_image(image_tag)

  # run the container
  sp_pg_docker_run(container_name,
                   image_tag = image_tag,
                   postgres_password = postgres_password
                   )

  # connect
  conn <- sp_get_postgres_connection(
    user = postgres_user,
    password = postgres_password,
    dbname = "dvdrental",
    seconds_to_test = 30
  )

  # list the tables
  tables <- DBI::dbListTables(conn)
  expect_equal(tables, table_list)

  # shut down and cleanup
  DBI::dbDisconnect(conn)
  sp_docker_remove_container(container_name)
  sp_docker_remove_image(image_tag)
})
