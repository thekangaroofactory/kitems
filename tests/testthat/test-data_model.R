

test_that("data_model works", {

  # //////////////////////////////////////////////////////////////////////////////
  # Argument check

  # -- basics (ok)
  data_model(colClasses = c(foo = "character"))
  data_model(colClasses = c(foo = "character", bar = "numeric"))
  data_model(colClasses = c(id = "numeric", foo = "character"))
  data_model(colClasses = c(id = "numeric", foo = "character", bar = "numeric"))

  # -- basics (ko)
  expect_error(data_model(colClasses = list(foo = "character")))
  expect_error(data_model(colClasses = c("character")))
  expect_error(data_model(colClasses = c(foo = "dummy")))


  # -- class.arg (ok)
  data_model(colClasses = c(foo = "Date"), class.arg = "origin = '1988-01-01'")
  data_model(colClasses = c(foo = "Date"), class.arg = c(foo = "origin = '1988-01-01'"))
  data_model(colClasses = c(foo = "Date", bar = "logical"), class.arg = c(foo = "origin = '1988-01-01'"))

  # -- class.arg (ko)
  expect_error(data_model(colClasses = c(foo = "Date", bar = "logical"), class.arg = "origin = '1988-01-01'"))


  # //////////////////////////////////////////////////////////////////////////////

  # -- default (ok)
  data_model(colClasses = c(foo = "character"), default = "foo")
  data_model(colClasses = c(foo = "character"), default = c(foo = "foo"))
  data_model(colClasses = c(foo = "character", bar = "numeric"), default = c(foo = "foo"))

  # -- default (ko)
  expect_error(data_model(colClasses = c(foo = "character", bar = "numeric"), default = "foo"))


  # -- default (ok)
  data_model(colClasses = c(foo = "Date"), default = "Sys.Date()")
  data_model(colClasses = c(foo = "Date"), default = c(foo = "Sys.Date()"))
  data_model(colClasses = c(foo = "Date", bar = "numeric"), default = c(foo = "Sys.Date()"))

  # -- default (ko)
  expect_error(data_model(colClasses = c(foo = "Date", bar = "numeric"), default = "Sys.Date()"))


  # -- default with arg (ok)
  data_model(colClasses = c(foo = "numeric"), default = "rnorm(1)")
  data_model(colClasses = c(foo = "numeric"), default = c(foo = "rnorm(1)"))
  data_model(colClasses = c(foo = "numeric", bar = "character"), default = c(foo = "rnorm(1)"))


  # //////////////////////////////////////////////////////////////////////////////

  # -- sort.rank (ok)
  data_model(colClasses = c(foo = "numeric"), sort.rank = 1L)
  data_model(colClasses = c(foo = "numeric"), sort.rank = c(foo = 1L))
  data_model(colClasses = c(foo = "numeric", bar = "character"), sort.rank = c(foo = 1L))

  # -- sort.rank (ko)
  expect_error(data_model(colClasses = c(foo = "numeric", bar = "character"), sort.rank = 1L))


  # -- sort.desc (ok)
  data_model(colClasses = c(foo = "numeric"), sort.rank = 1L)
  data_model(colClasses = c(foo = "numeric"), sort.rank = 1L, sort.desc = TRUE)
  data_model(colClasses = c(foo = "numeric"), sort.rank = 1L, sort.desc = FALSE)
  data_model(colClasses = c(foo = "numeric"), sort.rank = 1L, sort.desc = c(foo = TRUE))
  data_model(colClasses = c(foo = "numeric"), sort.rank = 1L, sort.desc = c(foo = FALSE))

  # -- sort.desc (ko)
  expect_error(data_model(colClasses = c(foo = "numeric", bar = "character"), sort.rank = c(foo = 1L), sort.desc = TRUE))
  expect_error(data_model(colClasses = c(foo = "numeric", bar = "character"), sort.rank = c(foo = 1L), sort.desc = FALSE))


  # //////////////////////////////////////////////////////////////////////////////

  # -- display (ok)
  data_model(colClasses = c(foo = "numeric"))
  data_model(colClasses = c(foo = "numeric"), display = TRUE) # useless
  data_model(colClasses = c(foo = "numeric"), display = FALSE)
  data_model(colClasses = c(foo = "numeric", bar = "character"))
  data_model(colClasses = c(foo = "numeric", bar = "character"), display = TRUE) # useless
  data_model(colClasses = c(foo = "numeric", bar = "character"), display = FALSE)

  # -- display (ko)
  expect_error(data_model(colClasses = c(foo = "numeric", bar = "character"), display = c(TRUE, FALSE)))


  # -- skip (ok)
  data_model(colClasses = c(foo = "numeric"))
  data_model(colClasses = c(foo = "numeric"), skip = TRUE)
  data_model(colClasses = c(foo = "numeric"), skip = FALSE) # useless
  data_model(colClasses = c(foo = "numeric", bar = "character"))
  data_model(colClasses = c(foo = "numeric", bar = "character"), skip = TRUE)
  data_model(colClasses = c(foo = "numeric", bar = "character"), skip = FALSE) # useless

  # -- skip (ko)
  expect_error(data_model(colClasses = c(foo = "numeric", bar = "character"), skip = c(TRUE, FALSE)))

  # -- refresh (ok)
  data_model(colClasses = c(foo = "numeric"))
  data_model(colClasses = c(foo = "numeric"), refresh = TRUE) # ignored
  data_model(colClasses = c(foo = "numeric"), refresh = FALSE) # ignored
  data_model(colClasses = c(foo = "numeric"), skip = TRUE, refresh = TRUE)
  data_model(colClasses = c(foo = "numeric"), skip = TRUE, refresh = FALSE) # useless
  data_model(colClasses = c(foo = "numeric", bar = "character"), skip = TRUE, refresh = TRUE)
  data_model(colClasses = c(foo = "numeric", bar = "character"), skip = TRUE, refresh = FALSE) # useless
  data_model(colClasses = c(foo = "numeric", bar = "character"), refresh = c(TRUE, FALSE)) # ignored

  # -- refresh (ko)
  expect_error(data_model(colClasses = c(foo = "numeric", bar = "character"), skip = TRUE, refresh = c(TRUE, FALSE)))


  # //////////////////////////////////////////////////////////////////////////////
  # Other scenarios

  # -- basics (missing id)
  colClasses <- c(name = "character")
  expect_message(x <- data_model(colClasses = c(name = "character")), "Adding missing id attribute")
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(2, length(DATA_MODEL_COLCLASSES)))
  expect_true("id" %in% x$name)

  # -- >>>>>>>>>>>>>>>>>>>>>> build scenarios from here!!!!
  expect_message(x <- data_model(colClasses), "Adding missing id attribute")
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(length(colClasses) + 1, length(DATA_MODEL_COLCLASSES)))
  expect_true("id" %in% x$name)

})
