

test_that("item_integrity Date (fix)", {

  # -- generate mismatch to solve
  items$date <- "2024-01-01"
  dm[dm$name == "date", ]$type <- "Date"

  # -- function call
  expect_warning(x <- item_integrity(items = items, data.model = dm, fix = TRUE))

  # -- test
  expect_equal(class(x$date), "Date")

})


test_that("item_integrity Date (check)", {

  # -- generate mismatch to solve
  items$date <- "2024-01-01"
  dm[dm$name == "date", ]$type <- "Date"

  # -- function call
  expect_error(item_integrity(items = items, data.model = dm))

})


test_that("item_integrity NULL items (fix)",
  expect_null(item_integrity(items = NULL, data.model = dm, fix = TRUE)))


test_that("item_integrity NULL items (check)",
  expect_null(item_integrity(items = NULL, data.model = dm)))


test_that("item_integrity / error (fix)", {

  # -- generate mismatch to solve
  items$date <- "dummy_string"
  dm[dm$name == "date", ]$type <- "Date"

  # -- function call
  expect_snapshot(x <- item_integrity(items = items, data.model = dm, fix = TRUE))

  # -- test
  expect_equal(class(x$date), "character")

})


test_that("item_integrity / error (check)", {

  # -- generate mismatch to solve
  items$date <- "dummy_string"
  dm[dm$name == "date", ]$type <- "Date"

  # -- function call
  expect_error(item_integrity(items = items, data.model = dm))

})


test_that("item_integrity / warning (fix)", {

  # -- generate mismatch to solve
  items$name <- "dummy_string"
  dm[dm$name == "name", ]$type <- "numeric"

  # -- function call
  expect_snapshot(x <- item_integrity(items = items, data.model = dm, fix = TRUE))

  # -- test
  expect_equal(class(x$name), "character")

})


test_that("item_integrity / warning (check)", {

  # -- generate mismatch to solve
  items$name <- "dummy_string"
  dm[dm$name == "name", ]$type <- "numeric"

  # -- function call
  expect_error(item_integrity(items = items, data.model = dm))

})
