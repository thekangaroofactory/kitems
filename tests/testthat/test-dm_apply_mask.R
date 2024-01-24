

test_that("dm_apply_mask", {

  # -- function call
  res <- dm_apply_mask(data.model = dm, items = items)

  # -- checks:
  expect_output(str(res), "data.frame")

  # -- check: output dim
  expect_equal(dim(res), c(4,3))

})


test_that("dm_apply_mask: no filter", {

  # -- function call
  res <- dm_apply_mask(data.model = dm_nofilter, items = items)

  # -- checks:
  expect_output(str(res), "data.frame")

  # -- check: output dim
  expect_equal(dim(res), c(4,4))

})
