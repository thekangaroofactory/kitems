

test_that("create_widget works", {

  # -- function call
  x <- create_widget(module_id)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(unlist(x), c(name = "span", attribs.id = "data-item_create_btn", attribs.class = "shiny-html-output"))

})


test_that("update_widget works", {

  # -- function call
  x <- update_widget(module_id)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(unlist(x), c(name = "span", attribs.id = "data-item_update_btn", attribs.class = "shiny-html-output"))

})


test_that("delete_widget works", {

  # -- function call
  x <- delete_widget(module_id)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(unlist(x), c(name = "span", attribs.id = "data-item_delete", attribs.class = "shiny-html-output"))

})
