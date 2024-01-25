

test_that("dm_skip", {

  # -- function call
  x <- dm_skip(data.model = dm)

  # -- check class
  expect_type(x, "character")

  # -- check output value
  expect_equal(x, "isvalid")

})


test_that("dm_skip: NULL data.model", {

  # -- function call
  x <- dm_skip(data.model = NULL)

  # -- check NULL output
  expect_null(x)

})
