

test_that("item_create", {

  # -- function call
  x <- item_create(values = values, data.model = dm)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(1,4))

  # -- test logical: #176
  expect_false(x$isvalid)

})
