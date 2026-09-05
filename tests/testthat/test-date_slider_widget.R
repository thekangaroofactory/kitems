

test_that("date_slider_widget works", {

  # -- function call
  x <- date_slider_widget(module_id)

  # -- tests
  expect_type(x, "list")
  expect_equal(length(x), 2)

})
