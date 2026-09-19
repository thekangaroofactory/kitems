

test_that("item_widget works", {

  # -- function call
  x <- item_widget(module_id)

  # -- test class
  expect_type(x, "list")
  expect_true(attributes(x)$class[[1]] == "shiny.tag.list")

})
