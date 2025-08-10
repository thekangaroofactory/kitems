
# -- create test file
create_testdata()

# -- base test -----------------------------------------------------------------
test_that("item_load works", {

  # -- function call
  x <- item_load(col.classes = dm_colClasses(dm), file = items_file, path = testdata_path)

  # -- default checks
  expect_items(x, n = nrow(items))
  expect_colclasses(x, colClasses)

})


# -- no file -------------------------------------------------------------------
test_that("item_load NULL dm works", {

  # -- function call
  x <- item_load(col.classes = dm_colClasses(NULL))

  # -- test output
  expect_null(x)

})

# -- data cleanup
clean_all()
