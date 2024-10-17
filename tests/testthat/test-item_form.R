

test_that("item_form: create", {

  # -- function call
  x <- item_form(ns = ns, data.model = dm_no_skip)

  # -- check class
  expect_type(x, "list")

})


test_that("item_form: update", {

  # -- function call
  x <- item_form(ns = ns, item = items[1, ], update = TRUE, data.model = dm)

  # -- check class
  expect_type(x, "list")

})
