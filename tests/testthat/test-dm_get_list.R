

test_that("dm_get_list", {

  # -- function call
  x <- dm_get_list(r = reactiveValues(dm1_data_model = 1, dm2_data_model = 2))

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(unlist(x), c("dm1", "dm2"))

})
