

test_that("rows_insert works", {

  # ////////////////////////////////////////////////////////////////////////////
  # Main cases

  # -- insert single item
  x <- rows_insert(items, list(name = "create", total = 200), dm)
  expect_equal(dim(x), dim(items) + c(1, 0))
  expect_equal(x$name[nrow(x)], "create")
  expect_equal(x$total[nrow(x)], 200)

  # -- insert multiple items
  x <- rows_insert(items, list(name = c("new_1", "new_2"), total = c(100, 200)), dm)
  expect_false(any(duplicated(x$id)))
  expect_equal(dim(x), dim(items) + c(2, 0))
  expect_equal(x$name[nrow(x) - 1], "new_1")
  expect_equal(x$total[nrow(x) - 1], 100)
  expect_equal(x$name[nrow(x)], "new_2")
  expect_equal(x$total[nrow(x)], 200)

  # -- create single item (items = NULL)
  x <- rows_insert(data.frame(), list(name = "create", total = 200), dm)
  expect_equal(nrow(x), 1)
  expect_equal(x$name, "create")

  # -- create multiple items (items = NULL)
  x <- rows_insert(data.frame(), list(total = 1:10), dm)
  expect_equal(nrow(x), 10)


  # ////////////////////////////////////////////////////////////////////////////
  # Specific cases coverage

  # -- drop unmatched columns
  x <- rows_insert(items, list(quantity = 100, dummy = "foo"), dm)
  expect_equal(dim(x), dim(items) + c(1, 0))

  # -- make rectangular
  x <- rows_insert(items, list(quantity = 100, total = c(1:4)), dm)
  expect_equal(dim(x), dim(items) + c(4, 0))

  # -- drop duplicated rows
  expect_error(rows_insert(items, list(id = items$id[1], quantity = 100), dm))
  expect_warning(x <- rows_insert(items, list(id = c(items$id[1], NA), quantity = 100), dm))
  expect_equal(dim(x), dim(items) + c(1, 0))

  # -- NULL element
  x <- rows_insert(items, list(id = NULL, quantity = 100), dm)
  expect_equal(dim(x), dim(items) + c(1, 0))

})
