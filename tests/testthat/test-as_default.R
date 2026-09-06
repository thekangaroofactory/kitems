
test_that("as_default works", {

  x <- as_default(item = items[2, ], data.model = yaml_to_dm(config, item = "foo", "name", "type", "default", "values"))
  expect_s3_class(x, c("tbl_df", "tbl", "data.frame"))
  expect_identical(dim(x), c(7, 3))

})
