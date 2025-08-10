

test_that("item_migrate works", {

  # -- function call
  x <- item_migrate(items = items, name = "new_attribute", type = "logical", fill = TRUE)

  # -- default checks
  expect_items(x, n = nrow(items))
  expect_colclasses(x, c(colClasses, new_attribute = "logical"))

  # -- test nb cols
  expect_equal(ncol(x), ncol(items) + 1)

  # -- test added attribute
  expect_equal(x$new_attribute, rep(TRUE,4))

})


test_that("item_migrate: items without row", {

  # -- function call
  x <- item_migrate(items = items_no_row, name = "new_attribute", type = "logical", fill = TRUE)

  # -- default checks
  expect_items(x, n = nrow(items_no_row))

  # -- test nb cols
  expect_equal(ncol(x), ncol(items_no_row) + 1)

})


test_that("item_migrate: wrong fill length", {

  # -- function call
  x <- item_migrate(items = items, name = "new_attribute", type = "logical", fill = c(TRUE, FALSE))

  # -- default checks
  expect_items(x, n = nrow(items))

  # -- test nb cols
  expect_equal(ncol(x), ncol(items) + 1)

})


test_that("item_migrate: wrong fill type", {

  # -- function call
  x <- item_migrate(items = items, name = "new_attribute", type = "logical", fill = 1)

  # -- default checks
  expect_items(x, n = nrow(items))

  # -- test nb cols
  expect_equal(ncol(x), ncol(items) + 1)

})

