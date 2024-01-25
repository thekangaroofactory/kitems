

test_that("input_date_slider", {

  # -- function call
  x <- input_date_slider(items = items, ns = ns)

  # -- chech that output is a closure
  expect_type(x, "closure")

})



test_that("input_date_slider: items has no row", {

  # -- function call
  x <- input_date_slider(items = items_no_row, ns = ns)

  # -- chech that output is a closure
  expect_type(x, "closure")

})
