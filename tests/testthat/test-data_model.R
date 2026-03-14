

test_that("data_model: colClasses", {

  # -- function call
  x <- data_model(colClasses = colClasses, default.val = NULL, default.fun = NULL, display = NULL, skip = NULL)

  # -- check: output is data.frame
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(length(colClasses), length(DATA_MODEL_COLCLASSES)))

})


test_that("data_model: missing id", {

  # -- function call
  expect_warning(x <- data_model(colClasses = colClasses[names(colClasses) != "id"]), "Adding missing id attribute")

  # -- check: output is data.frame
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(length(colClasses), length(DATA_MODEL_COLCLASSES)))

})


test_that("data_model: class.arg", {

  # -- function call
  x <- data_model(colClasses = colClasses, class.arg = c("date" = "list(format = 'a', origin = 'b')"))

  # -- check: output is data.frame
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(length(colClasses), length(DATA_MODEL_COLCLASSES)))
  expect_identical(x[x$name == "date", ]$class.arg, "list(format = 'a', origin = 'b')")

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


test_that("data_model: skip", {

  # -- function call
  x <- data_model(colClasses = colClasses, skip = names(colClasses))

  # -- checks
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(length(colClasses), length(DATA_MODEL_COLCLASSES)))
  expect_all_true(x$skip)
  expect_all_false(x$refresh)

})


test_that("data_model: skip & refresh", {

  # -- function call
  x <- data_model(colClasses = colClasses, skip = names(colClasses), refresh = names(colClasses))

  # -- checks
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(length(colClasses), length(DATA_MODEL_COLCLASSES)))
  expect_all_true(x$skip)
  expect_all_true(x$refresh)

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

