

test_that("create_BTN works", {

  # -- function call
  x <- create_BTN(module_id)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(unlist(x), c(name = "span", attribs.id = "data-item_create", attribs.class = "shiny-html-output"))

})


test_that("update_BTN works", {

  # -- function call
  x <- update_BTN(module_id)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(unlist(x), c(name = "span", attribs.id = "data-item_update", attribs.class = "shiny-html-output"))

})


test_that("delete_BTN works", {

  # -- function call
  x <- delete_BTN(module_id)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(unlist(x), c(name = "span", attribs.id = "data-item_delete", attribs.class = "shiny-html-output"))

})
