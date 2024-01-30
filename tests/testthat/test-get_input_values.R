

test_that("get_input_values", {

  # -- function call
  x <- get_input_values(input = input_values, colClasses = colClasses)

  # -- test output class
  expect_type(x, "list")

  # -- test output names
  expect_equal(names(x), names(colClasses))

  # -- test output values
  expect_equal(x, list(id = NULL, "date" = NULL, "name" = "myname", "quantity" = 12, "total" = 34.8, "isvalid" = NULL))

})
