

test_that("hide works", {

  # -- basics
  x <- hide(data_model(c(foo = "character")), "foo")
  expect_s3_class(x, "data.frame")
  expect_false(x[x$name == 'foo', 'display'])

  # -- unquoted
  x <- hide(data_model(c(foo = "character")), foo)
  expect_false(x[x$name == 'foo', 'display'])

  # -- multiples
  x <- hide(data_model(c(foo = "character", bar = "logical")), "foo", bar)
  expect_false(all(x['display']))

  # -- getter
  expect_identical(hide(data_model(c(foo = "character", bar = "logical"))), "id")

})


test_that("display works", {

  # -- basics
  x <- display(data_model(c(foo = "character")), "id")
  expect_s3_class(x, "data.frame")
  expect_true(x[x$name == 'id', 'display'])

  # -- unquoted
  x <- display(data_model(c(foo = "character")), id)
  expect_true(x[x$name == 'id', 'display'])

  # -- multiples
  x <- display(data_model(c(foo = "character", bar = "logical")), "id", bar)
  expect_true(all(x['display']))

  # -- getter
  expect_identical(display(data_model(c(foo = "character", bar = "logical"))), c("foo", "bar"))

})
