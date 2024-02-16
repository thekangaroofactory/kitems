

test_that("item_check_integrity works", {

  # -- generate mismatch to solve
  items$date <- "2024-01-01"

  # -- alter dm
  dm[dm$name == "date", ]$type <- "Date"

  # -- function call
  x <- item_check_integrity(items = items, data.model = dm)

  # -- test
  expect_equal(class(x$date), "Date")

})


test_that("item_check_integrity / NULL items works", {

  # -- function call
  x <- item_check_integrity(items = NULL, data.model = dm)

  # -- test
  expect_null(x)

})


test_that("item_check_integrity / error works", {

  # -- generate mismatch to solve
  items$date <- "dummy_string"

  # -- alter dm
  dm[dm$name == "date", ]$type <- "Date"

  # -- function call
  x <- item_check_integrity(items = items, data.model = dm)

  # -- test
  expect_equal(class(x$date), "character")

})
