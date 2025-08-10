
test_that("item_sort works", {

  # -- function call
  x <- item_sort(items, dm_sort)

  # -- default checks
  expect_items(x, n = nrow(items))
  expect_colclasses(x, colClasses)

})
