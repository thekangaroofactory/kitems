

test_that("items_filtered_view_DT works", {

  # -- function call
  x <- items_filtered_view_DT(module_id)

  # -- test class
  expect_type(x, "list")

})
