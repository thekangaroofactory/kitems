

test_that("filtered_view_ui works", {

  # -- function call
  x <- filtered_view_ui(module_id)

  # -- test class
  expect_type(x, "list")

})
