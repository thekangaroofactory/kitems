

test_that("create_BTN works", {

  # -- function call
  x <- create_BTN(module_id)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(unlist(x), c(name = "span", attribs.id = "data-create_btn_output", attribs.class = "shiny-html-output"))

})


test_that("update_BTN works", {

  # -- function call
  x <- update_BTN(module_id)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(unlist(x), c(name = "span", attribs.id = "data-update_btn_output", attribs.class = "shiny-html-output"))

})


test_that("delete_BTN works", {

  # -- function call
  x <- delete_BTN(module_id)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(unlist(x), c(name = "span", attribs.id = "data-delete_btn_output", attribs.class = "shiny-html-output"))

})
