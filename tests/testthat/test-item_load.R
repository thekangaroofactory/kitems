
# -- create test file
create_testdata()


test_that("item_load works", {

  # -- function call
  x <- item_load(data.model = dm, file = items_url, path = testdata_path, create = FALSE)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), dim(items))

})

# -- data cleanup
clean_all(testdata_path)
