

test_that("convert works", {

  # -- integer
  expect_type(convert(12, class = "integer"), "integer")
  expect_type(convert("12", class = "integer"), "integer")

  # -- numeric
  expect_type(convert(12L, class = "numeric"), "double")
  expect_type(convert("12", class = "numeric"), "double")

  # -- character
  expect_type(convert(12, class = "character"), "character")

  # -- date
  expect_s3_class(convert(as.numeric(Sys.Date()), class = "Date"), "Date")
  expect_s3_class(convert(as.numeric(Sys.Date(), format = "%Y%m%d"), class = "Date"), "Date")

  # -- with class.arg
  expect_no_condition(x <- convert("2025-09-10T13:16:55Z", "POSIXct", "list(format = '%Y-%m-%dT%H:%M:%S')"))
  expect_s3_class(x, c("POSIXct", "POSIXt"))
  expect_identical(as.character(x), "2025-09-10 13:16:55")

  # -- without class.arg
  expect_no_condition(x <- convert("2025-09-10T13:16:55Z", "POSIXct"))
  expect_s3_class(x, c("POSIXct", "POSIXt"))
  expect_identical(as.character(x), "2025-09-10")

  # -- logical
  expect_true(convert("TRUE", "logical"))
  expect_false(convert("F", "logical"))

})
