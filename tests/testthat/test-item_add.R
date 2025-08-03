

# -- test
test_that("item_add works", {

  # -- function call
  x <- item_add(items, new_item)

  # -- default checks
  expect_items(x, n = nrow(items) + 1)
  expect_colclasses(x, colClasses)

  # -- check added item
  expect_equal(x[nrow(x), ]$total, new_item$total)

})
