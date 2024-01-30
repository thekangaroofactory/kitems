

test_that("view_apply_masks works", {

  # -- function call
  x <- view_apply_masks(data.model = dm, items = items)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(dim(items)[1], sum(!dm$filter)))

  # -- test names (id is filtered)
  expect_equal(names(x), stringr::str_to_title(dm$name[!dm$filter]))

})
