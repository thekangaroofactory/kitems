

test_that("multiplication works", {

  # -- function call
  x <- view_apply_masks(data.model = dm, items = items)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(4,3))

  # -- test names (id is filtered)
  expect_equal(names(x), c("Date", "Name", "Isvalid"))

})
