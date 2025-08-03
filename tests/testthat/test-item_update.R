

test_that("item_update works", {

  # -- function call
  x <- item_update(items, update_item)

  # -- default checks
  expect_items(x, n = nrow(items))
  expect_colclasses(x, colClasses)

  # -- test updated name
  expect_equal(x[x$id == update_item$id, ]$name, "Apple-update")

})

test_that("item_update multiple works", {

  # -- function call
  x <- item_update(items, dplyr::bind_rows(update_item, update_item_2))

  # -- default checks
  expect_items(x, n = nrow(items))
  expect_colclasses(x, colClasses)

  # -- test updated name
  expect_equal(x[x$id == update_item$id, ]$name, "Apple-update")
  expect_equal(x[x$id == update_item_2$id, ]$name, "Banana-update")

})
