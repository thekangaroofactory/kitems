

# ------------------------------------------------------------------------------
# Init
# ------------------------------------------------------------------------------

# -- declare colClasses
colClasses <- c(id = "numeric", date = "POSIXct", name = "character", isvalid = "logical")

# -- declare default.val
default_val <- c("name" = "test", "isvalid" = TRUE)

# -- declare default.fun
default_fun <- c("date" = "Sys.Date")


# ------------------------------------------------------------------------------
# Tests
# ------------------------------------------------------------------------------

test_that("data_model: colClasses argument only", {

  # -- function call
  dm <- data_model(colClasses = colClasses, default.val = NULL, default.fun = NULL, filter = NULL, skip = NULL)

  # -- check: output is data.frame
  expect_output(str(dm), "data.frame")

  # -- check: output dim
  expect_equal(dim(dm), c(4,6))

})


test_that("data_model: default.val", {

  # -- function call
  dm <- data_model(colClasses = colClasses, default.val = default_val, default.fun = NULL, filter = NULL, skip = NULL)

  # -- check: output is data.frame
  expect_output(str(dm), "data.frame")

  # -- check: output dim
  expect_equal(dim(dm), c(4,6))

})


test_that("data_model: default.fun", {

  # -- function call
  dm <- data_model(colClasses = colClasses, default.val = NULL, default.fun = default_fun, filter = NULL, skip = NULL)

  # -- check: output is data.frame
  expect_output(str(dm), "data.frame")

  # -- check: output dim
  expect_equal(dim(dm), c(4,6))

})
