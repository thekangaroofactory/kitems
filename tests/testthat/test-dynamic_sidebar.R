

test_that("dynamic_sidebar", {

  # -- function call
  x <- dynamic_sidebar(r)

  # -- test output class
  expect_type(x, "list")

  # -- test output value
  expect_equal(x$attribs$class, "sidebar-menu")

})
