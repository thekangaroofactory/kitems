

test_that("dm_check_integrity", {

  # -- function call
  output <- dm_check_integrity(data.model = dm, items = items, template = NULL)

  # -- check
  expect_true(output)

})


test_that("dm_check_integrity: extra attribute in items", {

  # -- function call
  output <- dm_check_integrity(data.model = dm, items = items_extra_att, template = NULL)

  # -- checks:
  expect_output(str(output), "data.frame")

  # -- check: output dim
  expect_equal(dim(output), c(5,6))

})


test_that("dm_check_integrity: extra attribute in data model", {

  # -- function call
  output <- dm_check_integrity(data.model = dm_extra_att, items = items, template = NULL)

  # -- checks:
  expect_output(str(output), "data.frame")

  # -- check: output dim
  expect_equal(dim(output), c(4,6))

})
