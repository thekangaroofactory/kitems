

test_that("dm_filter: data.model NULL", {

  # -- function call
  x <- dm_filter(data.model = NULL)

  # -- check
  expect_null(x)

})


test_that("dm_filter: get filters", {

  # -- function call
  x <- dm_filter(data.model = dm)

  # -- check
  expect_equal(x, c("id"))

})


test_that("dm_filter: set filters", {

  # -- function call
  x <-dm_filter(data.model = dm_nofilter, set = filter)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test if filter is set
  expect_true(x[x$name == "id", ]$filter)


})
