

test_that("item_migrate", {

  # -- function call
  x <- item_migrate(items = items, name = "new_attribute", type = "logical", fill = TRUE)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), dim(items) + c(0, 1))

  # -- test added attribute
  expect_equal(x$new_attribute, rep(TRUE,4))

})


test_that("item_migrate: items without row", {

  # -- function call
  x <- item_migrate(items = items_no_row, name = "new_attribute", type = "logical", fill = TRUE)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(0,3))

})


test_that("item_migrate: wrong fill length", {

  # -- function call
  x <- item_migrate(items = items, name = "new_attribute", type = "logical", fill = c(TRUE, FALSE))

  # -- tests
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(4, 7))

})


test_that("item_migrate: wrong fill type", {

  # -- function call
  x <- item_migrate(items = items, name = "new_attribute", type = "logical", fill = 1)

  # -- tests
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(4, 7))

})

