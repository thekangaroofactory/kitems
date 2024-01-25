

test_that("date_slider_INPUT works", {

  # -- function call
  x <- date_slider_INPUT(module_id)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(unlist(x), c(name = "div", attribs.id = "data-date_slider", attribs.class = "shiny-html-output"))

})
