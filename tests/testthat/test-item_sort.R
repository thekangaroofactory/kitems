
# -- init data
dm <- data_model(colClasses = colClasses, sort.rank = c("date" = 1), sort.desc = c("date" = TRUE))


test_that("item_sort works", {

  # -- function call
  x <- item_sort(items, dm)

  # -- test class
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), dim(items))

})
