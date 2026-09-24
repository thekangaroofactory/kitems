

test_that("runExample works", {

  x <- runExample()
  expect_true(is.character(x) || length(x) == 0)

})
