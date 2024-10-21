
# -- test
test_that("item_sort works", {

  # -- function call
  x <- item_search(items, pattern = "Banana")

  # -- test class
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(1, 6))

  # -- function call
  x <- item_search(items, pattern = "an")

  # -- test class
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(3, 6))

  # -- function call
  x <- item_search(items, pattern = 2)

  # -- test class
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(4, 6))

})
