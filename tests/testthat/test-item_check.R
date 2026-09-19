
test_that("item_check works", {

  # -- baseline
  x <- item_check(items, config, id = "foo")
  expect_type(x, "list")
  expect_length(x, 0)

  # -- extra columns
  items_2 <- items
  items_2$dummy1 <- 12
  items_2$dummy2 <- "xxx"
  x <- item_check(items_2, config, id = "foo")
  expect_type(x, "list")
  expect_identical(x$code, 1)

  # -- missing column
  items_2 <- items
  items_2$date <- NULL
  x <- item_check(items_2, config, id = "foo")
  expect_type(x, "list")
  expect_identical(x$code, 2)

  # -- wrong type
  items_2 <- items
  items_2$total <- "xx"
  x <- item_check(items_2, config, id = "foo")
  expect_type(x, "list")
  expect_identical(x$code, 3)

})
