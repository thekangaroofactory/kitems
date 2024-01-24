

test_that("dm_apply_mask", {

  # -- function call
  res <- dm_apply_mask(data.model = dm, items = items)

  # -- checks:
  expect_output(str(res), "data.frame")

})
