
test_that("ask works", {

  # -- basics
  x <- ask(data_model(c(foo = "character"), skip = TRUE), "foo")
  expect_s3_class(x, "data.frame")
  expect_false(x[x$name == 'foo', 'skip'])

  # -- unquoted
  x <- ask(data_model(c(foo = "character"), skip = TRUE), foo)
  expect_false(x[x$name == 'foo', 'skip'])

  # -- multiples
  x <- ask(data_model(c(foo = "character", bar = "logical"), skip = TRUE), "foo", bar)
  expect_false(all(x['skip']))

  # -- getter
  expect_identical(ask(data_model(c(foo = "character", bar = "logical"))), c("foo", "bar"))

})
