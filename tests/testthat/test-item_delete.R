

test_that("item_delete", {

  # -- function call
  x <- item_delete(items = items, id = item_id)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(3,4))

  # -- test missing id
  expect_false(item_id %in% x$id)

})
