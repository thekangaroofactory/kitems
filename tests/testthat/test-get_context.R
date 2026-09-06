

test_that("get_context works", {

  # -- default (NULL if item not declared)
  expect_null(get_context())

  # -- baseline
  # need to encapsulate call (n = 2)
  item <- "foo"
  bar <- function() get_context()
  expect_identical(bar(), "foo")

})
