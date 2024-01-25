

test_that("dm_get_default: default.fun", {

  # -- function call
  x <- dm_get_default(data.model = dm, name = "date")

  # -- test class
  expect_type(x, "double")

  # -- test value
  expect_equal(x, as.Date(Sys.Date()))

})


test_that("dm_get_default: default.val", {

  # -- function call
  x <- dm_get_default(data.model = dm, name = "name")

  # -- test class
  expect_type(x, "character")

  # -- test value
  expect_equal(x, "test")

})


test_that("dm_get_default: NA", {

  # -- function call
  x <- dm_get_default(data.model = dm, name = "id")

  # -- test value is NA
  expect_true(is.na(x))

})