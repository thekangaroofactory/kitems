

test_that("item_update works", {

  # -- function call
  x <- item_update(items = items, item = item_update)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(4,4))

  # -- test updated name
  expect_equal(x[x$id == item_update$id, ]$name, "Apple-update")

})
