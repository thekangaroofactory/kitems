

test_that("item_reveal works", {

  # -- baseline
  x <- item_reveal(items, config, item = "foo")
  expect_s3_class(x, "data.frame")
  expect_identical(names(x), displayed(config, item = "foo"))

})
