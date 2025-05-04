

test_that("date_slider_widget works", {

  # -- function call
  x <- date_slider_widget(module_id)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(x$name, "div")
  expect_equal(x$attribs$class, "row")
  expect_equal(length(x$children), 2)
  expect_equal(length(unlist(x)), 12)

})
