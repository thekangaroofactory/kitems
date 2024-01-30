

test_that("dm_check_integrity", {

  # -- function call
  x <- dm_check_integrity(data.model = dm, items = items, template = NULL)

  # -- check
  expect_true(x)

})


test_that("dm_check_integrity: extra attribute in items", {

  # -- function call
  x <- dm_check_integrity(data.model = dm, items = items_extra_att, template = NULL)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: x dim
  expect_equal(dim(x), c(dim(dm)[1] + 1, 6))

})


test_that("dm_check_integrity: extra attribute in data model", {

  # -- function call
  x <- dm_check_integrity(data.model = dm_extra_att, items = items, template = NULL)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: x dim
  expect_equal(dim(x), c(dim(dm_extra_att)[1] - 1, 6))

})
