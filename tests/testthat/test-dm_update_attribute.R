

test_that("dm_update_attribute", {

  # -- function call
  x <- dm_update_attribute(data.model = dm, name = "isvalid", default.val = NA, default.fun = NA, filter = FALSE, skip = FALSE)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test output value
  expect_equal(as.character(x[x$name == "isvalid", ]$default.val), "NA")

})
