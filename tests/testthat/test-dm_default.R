

test_that("dm_default works", {

  # ////////////////////////////////////////////////////////////////////////////
  # default.fun

  # -- function call
  x <- dm_default(data.model = dm[dm$name == "date", ])$default

  # -- tests
  expect_equal(class(x), "character")
  expect_equal(x, as.character(Sys.Date()))


  # ////////////////////////////////////////////////////////////////////////////
  # default.fun with default.arg

  # -- function call
  x <- dm_default(data.model = dm[dm$name == "id", ])$default

  # -- tests
  expect_equal(class(x), "character")


  # ////////////////////////////////////////////////////////////////////////////
  # default.val

  # -- function call
  x <- dm_default(data.model = dm[dm$name == "name", ])$default

  # -- tests
  expect_type(x, "character")
  expect_equal(x, "fruit")

})
