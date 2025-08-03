
# -- case: multiple items with list of values (same length elements)
test_that("item_create multiple items works", {

  # -- function call
  x <- item_create(values_multiple, data.model = dm)

  # -- default checks
  expect_items(x, n = max(lengths(values_multiple)))
  expect_colclasses(x, colClasses)

})


# -- case: multiple items with list of values (different length elements)
test_that("item_create multiple items works", {

  # -- function call
  x <- item_create(values_multiple_lengths, data.model = dm)

  # -- default checks
  expect_items(x, n = max(lengths(values_multiple_lengths)))
  expect_colclasses(x, colClasses)

})
