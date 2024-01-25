

test_that("item_load works", {

  # -- function call
  x <- item_load(data.model = dm_test_file, file = test_file, path = path, create = FALSE)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(4,5))

})
