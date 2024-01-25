

test_that("get_input_values", {

  # -- init
  input <- list(name = "myname", value = 12)

  # -- function call
  x <- get_input_values(input = input, colClasses = colClasses)

  # -- test output class
  expect_type(x, "list")

  # -- test output names
  expect_equal(names(x), names(colClasses))

  # -- test output values
  expect_equal(x, list(id = NULL, "date" = NULL, "name" = "myname", "isvalid" = NULL))

})
