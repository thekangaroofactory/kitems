

test_that("dm_colClasses", {

  # -- check
  expect_mapequal(dm_colClasses(data.model = dm), c(id = "numeric", colClasses))

})
