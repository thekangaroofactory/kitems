

test_that("enforce works", {

  # -- add attribute
  x <- enforce(items = items, name = "new_attribute", type = "logical", fill = TRUE)

  # checks
  expect_items(x, n = nrow(items))
  expect_equal(ncol(x), ncol(items) + 1)
  expect_type(x$new_attribute, "logical")
  expect_equal(x$new_attribute, rep(TRUE, 4))


  # -- empty items
  x <- enforce(items[0, ], name = "new_attribute", type = "logical", fill = TRUE)

  # checks
  expect_items(x, n = 0)
  expect_equal(ncol(x), ncol(items) + 1)


  # -- wrong fill type
  x <- enforce(items = items, name = "new_attribute", type = "logical", fill = 1)

  # checks
  expect_items(x, n = nrow(items))
  expect_equal(ncol(x), ncol(items) + 1)

})

