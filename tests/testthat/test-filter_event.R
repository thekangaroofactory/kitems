

test_that("filter_event works", {

  # -- function call
  x <- filter_event()

  # -- check
  expect_true(is.list(x))
  expect_true(x$layer == "pre")
  expect_true(is.null(x$expr))

})


test_that("filter_event works", {

  # -- function call
  x <- filter_event(layer = "main")

  # -- check
  expect_true(is.list(x))
  expect_true(x$layer == "main")
  expect_true(is.null(x$expr))

})


test_that("filter_event works", {

  # -- function call
  x <- filter_event(layer = "pre", name == "Banana")

  # -- check
  expect_true(is.list(x))
  expect_true(x$layer == "pre")
  expect_true(is.language(x$expr[[1]]))

})


test_that("filter_event works", {

  # -- function call
  x <- filter_event(layer = "main", name == "Banana")

  # -- check
  expect_true(is.list(x))
  expect_true(x$layer == "main")
  expect_true(is.language(x$expr[[1]]))

})
