

test_that("item_delete", {

  # -- function call
  x <- item_delete(items, id = item_id)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), dim(items) - c(1, 0))

  # -- test missing id
  expect_false(item_id %in% x$id)

})
