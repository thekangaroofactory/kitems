

test_that("dm_update_attribute works", {

  # -- function call
  x <- dm_update_attribute(data.model = dm, name = "isvalid", default.val = NA, default.fun = NA, skip = FALSE)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test output value
  expect_true(is.na(x[x$name == "isvalid", ]$default.val))

})


test_that("dm_update_attribute / default.val", {

  # -- function call
  x <- dm_update_attribute(data.model = dm, name = "isvalid", default.val = TRUE, default.fun = NULL, skip = NULL)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test output value
  expect_equal(x[x$name == "isvalid", ]$default.val, "TRUE")

})


test_that("dm_update_attribute / default.fun", {

  # -- function call
  x <- dm_update_attribute(data.model = dm, name = "date", default.val = NULL, default.fun = "Sys.Date", skip = NULL)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test output value
  expect_equal(x[x$name == "date", ]$default.fun, "Sys.Date")

})

