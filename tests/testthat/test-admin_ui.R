

test_that("admin_ui works", {

  # -- function call
  x <- admin_ui(module_id)

  # -- test class
  expect_type(x, "list")

})
