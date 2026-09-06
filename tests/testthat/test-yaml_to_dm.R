

test_that("yaml_to_dm works", {

  x <- yaml_to_dm(config, name, default, values, item = "foo")
  expect_s3_class(x, c("tbl_df", "tbl", "data.frame"))

})
