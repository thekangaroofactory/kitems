

test_that("dm_add_attribute: add attribute", {

  # -- init
  colClasses <- c(id = "numeric", date = "POSIXct", name = "character", isvalid = "logical")

  # -- build data model
  dm <- data_model(colClasses = colClasses, default.val = NULL, default.fun = NULL, filter = NULL, skip = NULL)

  # -- test:
  res <- dm_add_attribute(data.model = dm,
                          name = "new_att",
                          type = "character",
                          default.val = NA,
                          default.fun = NA,
                          skip = FALSE,
                          filter = FALSE)

  # -- checks:
  expect_output(str(res), "data.frame")

  # -- check: output dim
  expect_equal(dim(res), c(5,6))

})
