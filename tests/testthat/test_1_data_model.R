

#----------------------------------
#  INIT
#----------------------------------

# data model
colClasses <- c(id = "numeric", date = "POSIXct", name = "character", isvalid = "logical")


#----------------------------------
#  TEST
#----------------------------------

test_that("data_model: colClasses argument only", {

  # -- function call
  dm <- data_model(colClasses, default.val = NULL, default.fun = NULL, filter = NULL, skip = NULL)

  # -- check: output is data.frame
  expect_output(str(dm), "data.frame")

  # -- check: output dim
  expect_equal(dim(dm), c(4,6))


})


