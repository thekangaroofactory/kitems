
# -- test
test_that("item_search works", {

  # -- function call
  x <- item_search(items, pattern = "Banana")

  # -- default checks
  expect_items(x)
  expect_colclasses(x, colClasses)

  # -- function call
  x <- item_search(items, pattern = "an")

  # -- default checks
  expect_items(x, n = 3)
  expect_colclasses(x, colClasses)

  # -- function call
  x <- item_search(items, pattern = 2)

  # -- default checks
  expect_items(x, n = 4)
  expect_colclasses(x, colClasses)

})
