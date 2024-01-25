

test_that("dm_filter_set", {

  # -- function call
  x <-dm_filter_set(data.model = dm_nofilter, filter = filter)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test if filter is set
  expect_true(x[x$name == "id", ]$filter)


})


test_that("dm_filter_set: NULL filter", {

  # -- function call
  x <- dm_filter_set(data.model = dm, filter = NULL)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test that output is same as data.model
  expect_mapequal(x, dm)


})
