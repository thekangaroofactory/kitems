

test_that("dm_filter: data.model NULL", {

  # -- function call
  x <- dm_filter(data.model = NULL)

  # -- check
  expect_null(x)

})
