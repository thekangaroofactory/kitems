

test_that("date_slider_widget works", {

  # -- function call
  x <- date_slider_widget(module_id)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(length(x), 2)

})
