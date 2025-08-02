

test_that("item_update works", {

  # -- function call
  x <- item_update(items, update_item)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), dim(items))

  # -- test updated name
  expect_equal(x[x$id == update_item$id, ]$name, "Apple-update")

})

test_that("item_update multiple works", {

  # -- function call
  x <- item_update(items, rbind(update_item, update_item_2))

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), dim(items))

  # -- test updated name
  expect_equal(x[x$id == update_item$id, ]$name, "Apple-update")
  expect_equal(x[x$id == update_item_2$id, ]$name, "Banana-update")

})
