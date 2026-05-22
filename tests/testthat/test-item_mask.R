

test_that("item_reveal works", {

  # -- function call
  x <- item_reveal(items = items, data.model = dm)

  # -- default checks
  expect_items(x, n = nrow(items))

  # -- test dim
  expect_equal(dim(x), c(dim(items)[1], sum(dm$display)))

  # -- test names (id is displayed)
  expect_equal(names(x), stringr::str_to_title(dm$name[dm$display]))

})
