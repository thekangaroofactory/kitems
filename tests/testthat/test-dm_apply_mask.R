

test_that("dm_apply_mask", {

  # -- function call
  x <- dm_apply_mask(data.model = dm, items = items)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(dim(items)[1], sum(!dm$filter)))

})


test_that("dm_apply_mask: no filter", {

  # -- function call
  x <- dm_apply_mask(data.model = dm_nofilter, items = items)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), dim(items))

})
