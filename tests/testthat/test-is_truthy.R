

test_that("is_truthy works", {

  # -- function call
  expect_false(is_truthy(NA))
  expect_false(is_truthy(NULL))
  expect_false(is_truthy(""))
  expect_false(is_truthy(numeric(0)))
  expect_false(is_truthy(character(0)))

  # -- function call
  expect_true(is_truthy(0))
  expect_true(is_truthy(runif(1)))
  expect_true(is_truthy(Sys.Date()))
  expect_true(is_truthy(Sys.time()))
  expect_true(is_truthy("Banana"))
  expect_true(is_truthy(FALSE))

})
