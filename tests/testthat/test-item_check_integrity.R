

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
