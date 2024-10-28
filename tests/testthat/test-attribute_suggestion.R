

test_that("attribute_suggestion character works", {

  # -- function call
  x <- attribute_suggestion(values = c(rep("a", 3), rep("b", 5), rep("c", 7)))

  # -- check
  expect_type(x, "list")
  expect_equal(names(x), c("c", "b", "a"))

})


test_that("attribute_suggestion numeric works", {

  # -- function call
  x <- attribute_suggestion(values = c(rep(1.2, 3), rep(2.5, 5), rep(8.9, 7)))

  # -- check
  expect_type(x, "list")
  expect_equal(names(x), c("8.9", "2.5", "1.2"))

  # -- function call
  x <- attribute_suggestion(values = c(rep(1.2, 3), rep(2.5, 5), rep(8.9, 7)), floor = 50)

  # -- check
  expect_type(x, "list")
  expect_equal(names(x), c("min", "max", "mean", "median"))

})


test_that("attribute_suggestion logical works", {

  # -- function call
  x <- attribute_suggestion(values = c(rep(TRUE, 3), rep(FALSE, 5)))

  # -- check
  expect_type(x, "list")
  expect_equal(names(x), c("true", "false"))

})


test_that("attribute_suggestion Date works", {

  # -- function call
  x <- attribute_suggestion(values = c(rep(as.Date(Sys.Date()), 3), rep(as.Date(Sys.Date() - 1), 5)))

  # -- check
  expect_type(x, "list")
  expect_equal(names(x), c("min", "max"))
  expect_equal(x$min, Sys.Date() -1)
  expect_equal(x$max, Sys.Date())

})


test_that("attribute_suggestion POSIXct works", {

  min <- as.POSIXct(Sys.Date() - 1)
  max <- as.POSIXct(Sys.Date())

  # -- function call
  x <- attribute_suggestion(values = c(rep(max, 3), rep(min, 5)))

  # -- check
  expect_type(x, "list")
  expect_equal(names(x), c("min", "max"))
  expect_equal(x$min, min)
  expect_equal(x$max, max)

})

