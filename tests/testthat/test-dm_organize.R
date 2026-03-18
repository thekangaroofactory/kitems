
test_that("organize works", {

  # -- init
  dm <- data_model(c(foo = "character", bar = "numeric", zoo = "logical"))

  # -- basics
  x <- organize(dm, "foo")
  expect_s3_class(x, "data.frame")
  expect_identical(dim(x), dim(dm))
  expect_equal(x[x$name == "foo", "sort.rank"], 1)
  expect_false(x[x$name == "foo", "sort.desc"])

  # -- unquoted
  x <- organize(dm, foo, desc(bar), zoo)
  expect_equal(x[!is.na(x$sort.rank), "sort.rank"], 1:3)
  expect_equal(x[!is.na(x$sort.rank), "sort.desc"], c(FALSE, TRUE, FALSE))

  # -- getter
  y <- organize(x)
  expect_s3_class(y, "data.frame")
  expect_equal(y[!is.na(y$sort.rank), "sort.rank"], 1:3)
  expect_equal(y[!is.na(y$sort.rank), "sort.desc"], c(FALSE, TRUE, FALSE))

})
