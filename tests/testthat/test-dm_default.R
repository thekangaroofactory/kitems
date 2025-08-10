

test_that("dm_default works", {

  # ////////////////////////////////////////////////////////////////////////////
  # default.fun

  # -- function call
  x <- dm_default(data.model = dm, name = "date")

  # -- tests
  expect_equal(class(x), c("POSIXct", "POSIXt"))
  expect_equal(as.Date(x), as.Date(Sys.Date()))


  # ////////////////////////////////////////////////////////////////////////////
  # default.fun with default.arg

  # -- function call
  x <- dm_default(data.model = dm, name = "id")

  # -- tests
  expect_true(is.numeric(x))


  # ////////////////////////////////////////////////////////////////////////////
  # default.fun multiple values

  # -- function call
  x <- dm_default(data.model = dm, name = "id", 10)

  # -- tests
  expect_true(is.numeric(x))
  expect_false(any(duplicated(x)))


  # ////////////////////////////////////////////////////////////////////////////
  # default.val

  # -- function call
  x <- dm_default(data.model = dm, name = "name")

  # -- tests
  expect_type(x, "character")
  expect_equal(x, "fruit")


  # ------------------------------------------------------------------------------
  # Negative tests
  # ------------------------------------------------------------------------------

  # -- alter data model
  dm_alter <- dm
  dm_alter[dm_alter$name == "date", ]$default.fun <- "dummy"

  # -- function call
  expect_warning(x <- dm_default(data.model = dm_alter, name = "date"))

  # -- test
  expect_true(is.na(x))

})
