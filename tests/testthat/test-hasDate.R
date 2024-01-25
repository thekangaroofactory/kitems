

test_that("hasDate: TRUE", {

  # -- function call
  x <- hasDate(data.model = dm)

  # -- test output
  expect_true(x)

})


test_that("hasDate: FALSE", {

  # -- function call
  x <- hasDate(data.model = dm_no_date)

  # -- test output
  expect_false(x)

})
