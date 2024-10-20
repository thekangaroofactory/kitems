
# -- create test file
create_testdata()

# -- base test -----------------------------------------------------------------
test_that("item_load works", {

  # -- function call
  x <- item_load(data.model = dm, file = items_url, path = testdata_path, create = FALSE)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), dim(items))

})


# -- no file -------------------------------------------------------------------
test_that("item_load NULL dm works", {

  # -- function call
  x <- item_load(data.model = NULL)

  # -- test output
  expect_null(x)

})

# -- data cleanup
clean_all(testdata_path)
