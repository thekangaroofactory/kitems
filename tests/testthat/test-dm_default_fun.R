

test_that("dm_default_fun", {

  # -- function call
  x <- dm_default_fun(data.model = dm)

  # -- test
  expect_mapequal(x, default_fun)

})
