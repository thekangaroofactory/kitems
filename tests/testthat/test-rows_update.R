

test_that("rows_update works", {

  # ////////////////////////////////////////////////////////////////////////////
  # Main cases

  # -- update single item
  x <- rows_update(items, list(id = items$id[1], name = "update", total = 200), dm)
  expect_equal(dim(x), dim(items))
  expect_equal(x$name[1], "update")
  expect_equal(x$total[1], 200)

  # -- update multiple items
  x <- rows_update(items, list(id = items$id[1:2], name = "update", total = 200), dm)
  expect_equal(dim(x), dim(items))
  expect_equal(x$name[1], "update")
  expect_equal(x$total[1], 200)
  expect_equal(x$name[2], "update")
  expect_equal(x$total[2], 200)


  # ////////////////////////////////////////////////////////////////////////////
  # Specific cases coverage

  # -- drop unmatched columns
  x <- rows_update(items, values_extra_col, dm)
  expect_equal(dim(x), dim(items))

  # -- make rectangular
  x <- rows_update(items, list(id = items$id, quantity = 100, total = c(1:4)), dm)
  expect_equal(dim(x), dim(items))

  # -- drop unmatched rows
  x <- rows_update(items, list(id = 123, quantity = 100), dm)
  expect_equal(dim(x), dim(items))

})
