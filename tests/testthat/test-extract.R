

test_that("extract works", {

  # -- simulate input object
  input_values_x <- list("id" = 170539948621,
                         "quantity" = 4,
                         "total" = 78.9,
                         "name" = "Orange",
                         "isvalid" = FALSE,
                         "date" = as.Date("2024-01-25", origin = "01-01-1970"),
                         "created" = as.Date("2024-01-25", origin = "01-01-1970"),
                         "created_time" = "14:15:30",
                         "created_tz" = "CET")

  # -- function call
  x <- extract(input = input_values_x,
                         colClasses = ci_classes(config, item = "foo"))

  # -- test output class
  expect_type(x, "list")
  expect_identical(names(x), c_attributes(config, item = "foo"))

  # -- test output values
  expect_equal(x$id, 170539948621)
  expect_true(x$date == as.Date("2024-01-25", origin = "01-01-1970"))
  expect_equal(x$name, "Orange")
  expect_equal(x$quantity, 4)
  expect_equal(x$total, 78.9)
  expect_false(x$isvalid)
  expect_true(x$created == as.POSIXct(paste("2024-01-25", "14:15:30"), tz = "CET"))


  # ------------------------------------------------------------------------------
  # Skip POSIXct attribute #427
  # Input will be missing, checking that we skip time & timezone
  # ------------------------------------------------------------------------------

  input_values_x <- list("id" = 170539948621,
                         "name" = "Orange",
                         "quantity" = 4,
                         "total" = 78.9,
                         "isvalid" = FALSE)

  # -- function call
  x <- extract(input = input_values_x,
                         colClasses = ci_classes(config, item = "foo"))

  # -- test output class
  expect_type(x, "list")
  expect_identical(names(x), c_attributes(config, item = "foo"))

  # -- test output values
  expect_equal(x$id, 170539948621)
  expect_null(x$date)
  expect_equal(x$name, "Orange")
  expect_equal(x$quantity, 4)
  expect_equal(x$total, 78.9)
  expect_false(x$isvalid)

})
