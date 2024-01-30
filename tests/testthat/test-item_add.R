

test_that("multiplication works", {

  # -- function call
  x <- item_add(items, new_item)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), dim(items) + c(1, 0))

  # -- test added attribute
  expect_equal(x[x$name == new_item$name, ]$total, new_item$total)

})
