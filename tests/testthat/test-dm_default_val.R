

test_that("dm_default_val", {

  # -- function call
  x <- dm_default_val(data.model = dm)

  # -- test
  expect_mapequal(x, default_val)

})
