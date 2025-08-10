

test_that("item_delete works", {

  # ////////////////////////////////////////////////////////////////////////////
  # single item

  # -- function call
  x <- rows_delete(items, id = item_id)

  # -- default checks
  expect_items(x, n = nrow(items) - 1)
  expect_colclasses(x, colClasses)

  # -- test id
  expect_false(item_id %in% x$id)


  # ////////////////////////////////////////////////////////////////////////////
  # multiple items

  # -- function call
  x <- rows_delete(items, id = items$id[2:3])

  # -- default checks
  expect_items(x, n = nrow(items) - 2)
  expect_colclasses(x, colClasses)

  # -- test id
  expect_false(all(items$id[2:3] %in% x$id))


  # ////////////////////////////////////////////////////////////////////////////
  # unmatched id

  # -- function call
  # id does not exist, so should fail
  expect_error(rows_delete(x, id = 1234))

})
