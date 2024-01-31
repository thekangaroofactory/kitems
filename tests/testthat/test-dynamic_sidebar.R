

test_that("dynamic_sidebar", {

  # -- function call
  x <- dynamic_sidebar(r = reactiveValues(dm1_data_model = 1, dm2_data_model = 2))

  # -- test output class
  expect_type(x, "list")

  # -- test output value
  expect_equal(x$attribs$class, "sidebar-menu")

})
