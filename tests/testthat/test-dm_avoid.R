
test_that("avoid works", {

  # -- basics
  x <- avoid(data_model(c(foo = "character")), "foo")
  expect_s3_class(x, "data.frame")
  expect_true(x[x$name == 'foo', 'skip'])

  # -- unquoted
  x <- avoid(data_model(c(foo = "character")), foo)
  expect_true(x[x$name == 'foo', 'skip'])

  # -- multiples
  x <- avoid(data_model(c(foo = "character", bar = "logical")), "foo", bar)
  expect_true(all(x['skip']))

  # -- getter
  expect_identical(avoid(data_model(c(foo = "character", bar = "logical"))), c("id"))

})
