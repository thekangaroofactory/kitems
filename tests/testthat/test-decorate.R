

test_that("decorate works", {

  x <- decorate(items)
  expect_s3_class(x, "data.frame")
  expect_identical(dim(x), dim(items))

})
