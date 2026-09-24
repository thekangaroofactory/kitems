
# -- create test file
create_testdata()

# -- base test -----------------------------------------------------------------
test_that("item_load works", {

  # -- function call
  x <- item_load(connector = list(file = name(module_id, file = T),
                                  path = testdata_path),
                 col.classes = ci_classes(config, item = "foo"))

  # -- default checks
  expect_items(x, n = nrow(items))

})

# -- data cleanup
clean_all()
