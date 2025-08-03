

test_that("item_mask works", {

  # -- function call
  x <- item_mask(data.model = dm, items = items)

  # -- default checks
  expect_items(x, n = nrow(items))

  # -- test dim
  expect_equal(dim(x), c(dim(items)[1], sum(!dm$filter)))

  # -- test names (id is filtered)
  expect_equal(names(x), stringr::str_to_title(dm$name[!dm$filter]))

})
