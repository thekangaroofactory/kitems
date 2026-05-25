
# -- create test file
create_testdata()

# -- base test -----------------------------------------------------------------
test_that("item_load works", {

  # -- function call
  x <- item_load(connector = list(file = items_file, path = testdata_path),
                 col.classes = dm_colClasses(dm))

  # -- default checks
  expect_items(x, n = nrow(items))
  expect_colclasses(x, dm_colClasses(dm))

})

# -- data cleanup
clean_all()
