

test_that("item_delete works", {

  # -- function call
  x <- item_delete(items, id = item_id)

  # -- default checks
  expect_items(x, n = nrow(items) - 1)
  expect_colclasses(x, colClasses)

  # -- test missing id
  expect_false(item_id %in% x$id)

})


test_that("item_delete not found id works", {

  # -- function call
  # id does not exist, so should fail
  expect_error(item_delete(x, id = 1234))

})
