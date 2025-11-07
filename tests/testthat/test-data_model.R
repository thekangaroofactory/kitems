

test_that("data_model: colClasses argument only", {

  # -- function call
  x <- data_model(colClasses = colClasses, default.val = NULL, default.fun = NULL, display = NULL, skip = NULL)

  # -- check: output is data.frame
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(length(colClasses), length(DATA_MODEL_COLCLASSES)))

})


test_that("data_model: default.val", {

  # -- function call
  x <- data_model(colClasses = colClasses, default.val = default_val, default.fun = NULL, display = NULL, skip = NULL)

  # -- check: output is data.frame
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(length(colClasses), length(DATA_MODEL_COLCLASSES)))

})


test_that("data_model: default.fun", {

  # -- function call
  x <- data_model(colClasses = colClasses, default.val = NULL, default.fun = default_fun, display = NULL, skip = NULL)

  # -- check: output is data.frame
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(length(colClasses), length(DATA_MODEL_COLCLASSES)))

})


test_that("data_model: default.arg", {

  # -- function call
  x <- data_model(colClasses = colClasses, default.fun = default_fun, default.arg = default_arg)

  # -- check: output is data.frame
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(length(colClasses), length(DATA_MODEL_COLCLASSES)))

})


test_that("data_model: sort", {

  # -- function call
  x <- data_model(colClasses = colClasses, sort.rank = c("date" = 1), sort.desc = c("date" = TRUE))

  # -- check: output is data.frame
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(length(colClasses), length(DATA_MODEL_COLCLASSES)))

})


# ------------------------------------------------------------------------------
# Negative test(s)
# ------------------------------------------------------------------------------

test_that("data_model: colClasses not named", {

  # -- check: error
  expect_error(data_model(colClasses = c(1, 2)))

})

