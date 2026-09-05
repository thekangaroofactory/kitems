

test_that("create_widget works", {

  # -- function call
  x <- create_widget(module_id)

  # -- tests
  expect_type(x, "list")
  expect_equal(unlist(x), c(name = "span", attribs.id = paste0(module_id, "-item_create_btn"), attribs.class = "shiny-html-output"))

})


test_that("update_widget works", {

  # -- function call
  x <- update_widget(module_id)

  # -- tests
  expect_type(x, "list")
  expect_equal(unlist(x), c(name = "span", attribs.id = paste0(module_id, "-item_update_btn"), attribs.class = "shiny-html-output"))

})


test_that("delete_widget works", {

  # -- function call
  x <- delete_widget(module_id)

  # -- tests
  expect_type(x, "list")
  expect_equal(unlist(x), c(name = "span", attribs.id = paste0(module_id, "-item_delete_btn"), attribs.class = "shiny-html-output"))

})
