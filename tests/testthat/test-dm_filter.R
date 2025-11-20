

test_that("dm_display: data.model NULL", {

  # -- function call
  x <- dm_display(data.model = NULL)

  # -- check
  expect_null(x)

})


test_that("dm_display: get displays", {

  # -- function call
  x <- dm_display(data.model = dm)

  # -- check
  expect_equal(x, c("id"))

})


test_that("dm_display: get displays (no display set)", {

  # -- function call
  x <- dm_display(data.model = dm_nodisplay)

  # -- check
  expect_null(x)

})


test_that("dm_display: set / unset displays", {

  # -- function call
  x <-dm_display(data.model = dm_nodisplay, set = display)

  # -- test class & display
  expect_s3_class(x, "data.frame")
  expect_true(x[x$name == "id", ]$display)

  # -- function call
  x <-dm_display(data.model = x, set = "date")

  # -- test class & display
  expect_s3_class(x, "data.frame")
  expect_false(x[x$name == "id", ]$display)
  expect_true(x[x$name == "date", ]$display)

})
