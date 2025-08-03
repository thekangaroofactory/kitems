

test_that("item_create works", {

  # -- function call
  x <- item_create(values = values, data.model = dm)

  # -- default checks
  expect_items(x)
  expect_colclasses(x, colClasses)

  # -- specific check: test logical #176
  expect_false(x$isvalid)

})


test_that("item_create fails with missing value", {

  # -- function call
  expect_error(item_create(values[!names(values) %in% "name"], data.model = dm))

})


# -- adding coverage #428
test_that("item_create works with length(0) value", {

  # -- prepare values
  values_0 <- values
  values_0$date <- as.Date(numeric(0))

  # -- function call
  x <- item_create(values_0, data.model = dm)

  # -- default checks
  expect_items(x)
  expect_colclasses(x, colClasses)

  # -- specific check
  expect_true(inherits(x$date, "POSIXct"))

})
