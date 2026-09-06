

test_that("mask works", {

  x <- mask(items)
  expect_s3_class(x, "data.frame")
  expect_identical(dim(x), dim(items))

})
