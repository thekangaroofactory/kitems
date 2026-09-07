

test_that("get_context works", {

  # -- default (NULL if item not declared)
  expect_warning(x <- get_context())
  expect_null(x)

  # -- baseline
  # need to encapsulate call (n = 2)
  item <- "foo"
  bar <- function() get_context()
  expect_identical(bar(), "foo")

})
