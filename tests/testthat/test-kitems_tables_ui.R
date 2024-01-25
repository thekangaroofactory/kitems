

test_that("items_view_DT works", {

  # -- function call
  x <- items_view_DT(module_id)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(unlist(x)[["name"]], "div")
  expect_equal(unlist(x)[["attribs.id"]], "data-default_view")
  expect_match(unlist(x)[["attribs.class"]], "datatables html-widget html-widget-output")

})


test_that("items_filtered_view_DT works", {

  # -- function call
  x <- items_filtered_view_DT(module_id)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(unlist(x)[["name"]], "div")
  expect_equal(unlist(x)[["attribs.id"]], "data-filtered_view")
  expect_match(unlist(x)[["attribs.class"]], "datatables html-widget html-widget-output")

})
