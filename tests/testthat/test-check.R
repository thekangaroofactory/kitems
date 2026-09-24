
test_that("check works", {

  # -- no argument supplied to ...
  expect_error(check())

  # -- config
  # code 8 "Item 1 has no item file"
  x <- check(config)
  expect_type(x, "list")
  expect_identical(x[[1]]$code, 8)

  # -- items
  x <- check(items, config, id = "foo")
  expect_type(x, "list")

})
