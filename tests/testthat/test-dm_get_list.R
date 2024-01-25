

test_that("dm_get_list", {

  # -- function call
  x <- dm_get_list(r)

  # -- test class
  expect_type(x, "list")

  # -- test output
  expect_equal(unlist(x), c("dm1", "dm2"))

})
