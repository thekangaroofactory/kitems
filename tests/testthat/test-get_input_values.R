

# -- setup
input_values_x <- list("id" = c(170539948621),
            "date" = c(as.Date("2024-01-25", origin = "01-01-1970")),
            "date_time" = "14:15:30",
            "date_tz" = "CET",
            "name" = c("Orange"),
            "quantity" = 4,
            "total" = 78.9,
            "isvalid" = c(FALSE))


test_that("get_input_values", {

  # -- function call
  x <- get_input_values(input = input_values_x, colClasses = colClasses)

  # -- test output class
  expect_type(x, "list")

  # -- test output names
  expect_equal(names(x), names(colClasses))

  # -- test output values
  expect_equal(x$id, 170539948621)
  expect_true(x$date == as.POSIXct(paste("2024-01-25", "14:15:30"), tz = "CET"))
  expect_equal(x$name, "Orange")
  expect_equal(x$quantity, 4)
  expect_equal(x$total, 78.9)
  expect_false(x$isvalid)

})
