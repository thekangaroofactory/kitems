

test_that("filtered_view_widget works", {

  # -- function call
  x <- filtered_view_widget(module_id)

  # -- test class
  expect_type(x, "list")
  expect_true(attributes(x)$class[[1]] == "shiny.tag.list")

})
