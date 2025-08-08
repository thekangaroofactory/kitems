

test_that("dm_default: default.fun", {

  # -- function call
  x <- dm_default(data.model = dm, name = "date")

  # -- test class
  expect_equal(class(x), c("POSIXct", "POSIXt"))

  # -- test value
  expect_equal(as.Date(x), as.Date(Sys.Date()))

})


test_that("dm_default: default.val", {

  # -- function call
  x <- dm_default(data.model = dm, name = "name")

  # -- test class
  expect_type(x, "character")

  # -- test value
  expect_equal(x, "fruit")

})


test_that("dm_default: NA", {

  # -- function call
  x <- dm_default(data.model = dm, name = "id")

  # -- test value is NA
  expect_true(is.numeric(x))

})


# ------------------------------------------------------------------------------
# Negative tests
# ------------------------------------------------------------------------------

test_that("dm_default / default.fun error", {

  # -- alter data model
  dm[dm$name == "date", ]$default.fun <- "as.Date"

  # -- function call
  x <- dm_default(data.model = dm, name = "date")

  # -- test value is NA
  expect_true(is.na(x))

})
