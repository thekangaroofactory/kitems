

test_that("attribute_update works", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "isvalid", default.val = NA, default.fun = NA, skip = FALSE)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test output value
  expect_true(is.na(x[x$name == "isvalid", ]$default.val))

})


test_that("attribute_update / default.val", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "name", default.val = "blueberry", default.fun = NULL, skip = NULL)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test output value
  expect_equal(x[x$name == "name", ]$default.val, "blueberry")

})


test_that("attribute_update / default.fun", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "date", default.val = NULL, default.fun = "Sys.Date", skip = NULL)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test output value
  expect_equal(x[x$name == "date", ]$default.fun, "Sys.Date")

})


test_that("attribute_update / default.fun + default.arg", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "id", default.fun = "ktools::getTimestamp", default.arg = "list(k = 10)")

  # -- tests
  expect_s3_class(x, "data.frame")
  expect_equal(x[x$name == "id", ]$default.fun, "ktools::getTimestamp")
  expect_equal(x[x$name == "id", ]$default.arg, "list(k = 10)")

})


test_that("attribute_update / filter", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "name", filter = TRUE)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test output value
  expect_true(x[x$name == "name", ]$filter)

})


test_that("attribute_update / sort.rank & sort.desc", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "name", sort.rank = 1, sort.desc = TRUE)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test output value
  expect_equal(x[x$name == "name", ]$sort.rank, 1)
  expect_true(x[x$name == "name", ]$sort.desc)

})

