

test_that("item_delete", {

  # -- function call
  x <- item_delete(items, id = item_id)

  # -- test class & dim
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), dim(items) - c(1, 0))

  # -- test missing id
  expect_false(item_id %in% x$id)


  # -- function call (id does not exist, so should fail)
  expect_error(item_delete(x, id = item_id))


})
