

test_that("filtered_view_widget works", {

  # -- function call
  x <- filtered_view_widget(module_id)

  # -- test class
  expect_type(x, "list")

})
