

test_that("data_model: colClasses argument only", {

  # -- function call
  x <- data_model(colClasses = colClasses, default.val = NULL, default.fun = NULL, filter = NULL, skip = NULL)

  # -- check: output is data.frame
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(length(colClasses), 6))

})


test_that("data_model: default.val", {

  # -- function call
  x <- data_model(colClasses = colClasses, default.val = default_val, default.fun = NULL, filter = NULL, skip = NULL)

  # -- check: output is data.frame
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(length(colClasses), 6))

})


test_that("data_model: default.fun", {

  # -- function call
  x <- data_model(colClasses = colClasses, default.val = NULL, default.fun = default_fun, filter = NULL, skip = NULL)

  # -- check: output is data.frame
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(length(colClasses), 6))

})


# ------------------------------------------------------------------------------
# Negative test(s)
# ------------------------------------------------------------------------------

test_that("data_model: colClasses not named", {

  # -- check: error
  expect_error(data_model(colClasses = c(1, 2)))

})

