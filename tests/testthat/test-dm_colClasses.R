

test_that("dm_colClasses", {

  # -- function call
  x <- dm_colClasses(data.model = dm)

  # -- test
  expect_mapequal(x, colClasses)

})
