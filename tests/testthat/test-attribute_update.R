

test_that("attribute_update works", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "isvalid", default = FALSE)

  # -- checks
  expect_s3_class(x, "data.frame")
  expect_true(is.na(x[x$name == "isvalid", ]$default))

})


test_that("attribute_update / class.arg", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "date", class.arg = "list(format = '%Y-%m-%dT%H:%M:%S')")

  # -- checks
  expect_s3_class(x, "data.frame")
  expect_identical(x[x$name == "date", ]$class.arg, "list(format = '%Y-%m-%dT%H:%M:%S')")

})


test_that("attribute_update / default", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "name", default = "blueberry")

  # -- checks
  expect_s3_class(x, "data.frame")
  expect_equal(x[x$name == "name", ]$default, "blueberry")

})


test_that("attribute_update / default", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "date", default = "Sys.Date()")

  # -- checks
  expect_s3_class(x, "data.frame")
  expect_equal(x[x$name == "date", ]$default, "Sys.Date()")

})


test_that("attribute_update / default + default.arg", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "id", default = "ktools::getTimestamp(k = 10)")

  # -- checks
  expect_s3_class(x, "data.frame")
  expect_equal(x[x$name == "id", ]$default, "ktools::getTimestamp(k = 10)")

})


test_that("attribute_update / display", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "name", display = TRUE)

  # -- checks
  expect_s3_class(x, "data.frame")
  expect_true(x[x$name == "name", ]$display)

})


test_that("attribute_update / skip", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "name", skip = TRUE)

  # -- checks
  expect_s3_class(x, "data.frame")
  expect_true(x[x$name == "name", ]$skip)
  expect_false(x[x$name == "name", ]$refresh)

})


test_that("attribute_update / skip + refresh", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "name", skip = TRUE, refresh = TRUE)

  # -- checks
  expect_s3_class(x, "data.frame")
  expect_true(x[x$name == "name", ]$skip)
  expect_true(x[x$name == "name", ]$refresh)

})


test_that("attribute_update / sort.rank & sort.desc", {

  # -- function call
  x <- attribute_update(data.model = dm, name = "name", sort.rank = 1L, sort.desc = TRUE)

  # -- checks
  expect_s3_class(x, "data.frame")
  expect_equal(x[x$name == "name", ]$sort.rank, 1)
  expect_true(x[x$name == "name", ]$sort.desc)

})
