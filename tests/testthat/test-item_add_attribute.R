

test_that("item_add_attribute", {

  # -- function call
  x <- item_add_attribute(items = items, name = "new_attribute", type = "logical", fill = TRUE)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), dim(items) + c(0, 1))

  # -- test added attribute
  expect_equal(x$new_attribute, rep(TRUE,4))

})


test_that("item_add_attribute: items without row", {

  # -- function call
  x <- item_add_attribute(items = items_no_row, name = "new_attribute", type = "logical", fill = TRUE)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(0,3))

})

