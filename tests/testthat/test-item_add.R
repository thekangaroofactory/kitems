

# -- test
test_that("item_add works", {

  # -- function call
  x <- item_add(items, new_item)

  # -- test class & dim
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), dim(items) + c(1, 0))

  # -- test added attribute
  expect_equal(x[x$name == new_item$name, ]$total, new_item$total)

})
