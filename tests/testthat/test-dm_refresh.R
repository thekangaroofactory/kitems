
test_that("refresh works", {

  # -- basics
  x <- refresh(data_model(c(foo = "character"), skip = TRUE), "foo")
  expect_s3_class(x, "data.frame")
  expect_true(x[x$name == 'foo', 'refresh'])

  # -- unquoted
  x <- refresh(data_model(c(foo = "character"), skip = TRUE), foo)
  expect_true(x[x$name == 'foo', 'refresh'])

  # -- multiples
  x <- refresh(data_model(c(foo = "character", bar = "logical"), skip = TRUE), "foo", bar)
  expect_true(all(x[x$name %in% c("foo", "bar"), 'refresh']))

  # -- negative (id)
  expect_error(refresh(data_model(c(foo = "character"), skip = TRUE), id), "It's forbidden to refresh the id attribute")

  # -- getter
  x <- refresh(data_model(c(foo = "character", bar = "logical"), skip = TRUE), "foo", "bar")
  expect_identical(x[x$refresh, 'name'], c("foo", "bar"))

})
