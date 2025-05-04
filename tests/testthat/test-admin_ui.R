

test_that("admin_widget works", {

  # -- function call
  x <- admin_widget(module_id)

  # -- test class
  expect_type(x, "list")

})
