

test_that("attribute_value works", {

  # -- integer
  expect_no_error(attribute_value(key = "quantity", value = NA, data.model = dm))
  expect_no_error(attribute_value(key = "quantity", value = NULL, data.model = dm))
  expect_no_error(attribute_value(key = "quantity", value = integer(0), data.model = dm))
  expect_no_error(attribute_value(key = "quantity", value = 0, data.model = dm))
  expect_no_error(attribute_value(key = "quantity", value = round(runif(1, 1, 100), digits = 0), data.model = dm))
  expect_no_error(attribute_value(key = "quantity", value = runif(1, 1, 100), data.model = dm))
  expect_no_error(attribute_value(key = "quantity", value = "12", data.model = dm))

  # -- numeric
  expect_no_error(attribute_value(key = "total", value = NA, data.model = dm))
  expect_no_error(attribute_value(key = "total", value = NULL, data.model = dm))
  expect_no_error(attribute_value(key = "total", value = numeric(0), data.model = dm))
  expect_no_error(attribute_value(key = "total", value = runif(1, 1, 100), data.model = dm))
  expect_no_error(attribute_value(key = "total", value = round(runif(1, 1, 100), digits = 0), data.model = dm))
  expect_no_error(attribute_value(key = "total", value = "12.5", data.model = dm))

  # -- character
  expect_no_error(attribute_value(key = "name", value = NA, data.model = dm))
  expect_no_error(attribute_value(key = "name", value = NULL, data.model = dm))
  expect_no_error(attribute_value(key = "name", value = character(0), data.model = dm))
  expect_no_error(attribute_value(key = "name", value = paste0(letters[round(runif(5, 1, 26), digits = 0)], collapse = ""), data.model = dm))
  expect_no_error(attribute_value(key = "name", value = 12.5, data.model = dm))

  # -- POSIXct
  expect_no_error(attribute_value(key = "date", value = NA, data.model = dm))
  expect_no_error(attribute_value(key = "date", value = NULL, data.model = dm))
  expect_no_error(attribute_value(key = "date", value = Sys.Date(), data.model = dm))
  expect_no_error(attribute_value(key = "date", value = Sys.time(), data.model = dm))
  expect_no_error(attribute_value(key = "date", value = "2025/12/25", data.model = dm))

  # -- logical
  expect_no_error(attribute_value(key = "isvalid", value = NA, data.model = dm))
  expect_no_error(attribute_value(key = "isvalid", value = NULL, data.model = dm))
  expect_no_error(attribute_value(key = "isvalid", value = logical(0), data.model = dm))
  expect_no_error(attribute_value(key = "isvalid", value = TRUE, data.model = dm))
  expect_no_error(attribute_value(key = "isvalid", value = FALSE, data.model = dm))

})
