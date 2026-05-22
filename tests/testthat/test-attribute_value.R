

test_that("attribute_values works", {

  # -- integer
  expect_no_error(attribute_values(values = c(quantity = NA), data.model = dm))
  expect_no_error(attribute_values(values = c(quantity = NULL), data.model = dm))
  expect_no_error(attribute_values(values = c(quantity = integer(0)), data.model = dm))
  expect_no_error(attribute_values(values = c(quantity = 0), data.model = dm))
  expect_no_error(attribute_values(values = c(quantity = round(runif(1, 1, 100), digits = 0)), data.model = dm))
  expect_no_error(attribute_values(values = c(quantity = runif(1, 1, 100)), data.model = dm))
  expect_no_error(attribute_values(values = c(quantity = "12"), data.model = dm))

  # -- numeric
  expect_no_error(attribute_values(values = c(total = NA), data.model = dm))
  expect_no_error(attribute_values(values = c(total = NULL), data.model = dm))
  expect_no_error(attribute_values(values = c(total = numeric(0)), data.model = dm))
  expect_no_error(attribute_values(values = c(total = runif(1, 1, 100)), data.model = dm))
  expect_no_error(attribute_values(values = c(total = round(runif(1, 1, 100), digits = 0)), data.model = dm))
  expect_no_error(attribute_values(values = c(total = "12.5"), data.model = dm))

  # -- character
  expect_no_error(attribute_values(values = c(name = NA), data.model = dm))
  expect_no_error(attribute_values(values = c(name = NULL), data.model = dm))
  expect_no_error(attribute_values(values = c(name = character(0)), data.model = dm))
  expect_no_error(attribute_values(values = c(name = paste0(letters[round(runif(5, 1, 26), digits = 0)], collapse = "")), data.model = dm))
  expect_no_error(attribute_values(values = c(name = 12.5), data.model = dm))

  # -- POSIXct
  expect_no_error(attribute_values(values = c(date = NA), data.model = dm))
  expect_no_error(attribute_values(values = c(date = NULL), data.model = dm))
  expect_no_error(attribute_values(values = c(date = Sys.Date()), data.model = dm))
  expect_no_error(attribute_values(values = c(date = Sys.time()), data.model = dm))
  expect_no_error(attribute_values(values = c(date = "2025/12/25"), data.model = dm))

  # -- logical
  expect_no_error(attribute_values(values = c(isvalid = NA), data.model = dm))
  expect_no_error(attribute_values(values = c(isvalid = NULL), data.model = dm))
  expect_no_error(attribute_values(values = c(isvalid = logical(0)), data.model = dm))
  expect_no_error(attribute_values(values = c(isvalid = TRUE), data.model = dm))
  expect_no_error(attribute_values(values = c(isvalid = FALSE), data.model = dm))

})
