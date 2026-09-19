

test_that("reveal works", {

  # -- baseline
  x <- reveal(items, config, item = "foo")
  expect_s3_class(x, "data.frame")
  expect_identical(names(x), displayed(config, item = "foo"))

})
