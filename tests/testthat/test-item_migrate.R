

test_that("item_migrate works", {

  # -- add attribute
  x <- item_migrate(items = items, name = "new_attribute", type = "logical", fill = TRUE)

  # checks
  expect_items(x, n = nrow(items))
  expect_equal(ncol(x), ncol(items) + 1)
  expect_type(x$new_attribute, "logical")
  expect_equal(x$new_attribute, rep(TRUE, 4))


  # -- empty items
  x <- item_migrate(items = items_no_row, name = "new_attribute", type = "logical", fill = TRUE)

  # checks
  expect_items(x, n = nrow(items_no_row))
  expect_equal(ncol(x), ncol(items_no_row) + 1)


  # -- wrong fill type
  x <- item_migrate(items = items, name = "new_attribute", type = "logical", fill = 1)

  # checks
  expect_items(x, n = nrow(items))
  expect_equal(ncol(x), ncol(items) + 1)

})

