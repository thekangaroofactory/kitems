

test_that("dm_add_attribute: add attribute", {

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


test_that("dm_add_attribute: empty default.val", {

  # -- test:
  res <- dm_add_attribute(data.model = dm,
                          name = "new_att",
                          type = "character",
                          default.val = "",
                          default.fun = NA,
                          skip = FALSE,
                          filter = FALSE)

  # -- checks:
  expect_output(str(res), "data.frame")

  # -- check: output dim
  expect_equal(dim(res), c(5,6))

})


test_that("dm_add_attribute: empty default.fun", {

  # -- test:
  res <- dm_add_attribute(data.model = dm,
                          name = "new_att",
                          type = "character",
                          default.val = NA,
                          default.fun = "",
                          skip = FALSE,
                          filter = FALSE)

  # -- checks:
  expect_output(str(res), "data.frame")

  # -- check: output dim
  expect_equal(dim(res), c(5,6))

})


test_that("dm_add_attribute: skip NULL", {

  # -- test:
  res <- dm_add_attribute(data.model = dm,
                          name = "new_att",
                          type = "character",
                          default.val = NA,
                          default.fun = NA,
                          skip = NULL,
                          filter = FALSE)

  # -- checks:
  expect_output(str(res), "data.frame")

  # -- check: output dim
  expect_equal(dim(res), c(5,6))

})


test_that("dm_add_attribute: filter NULL", {

  # -- test:
  res <- dm_add_attribute(data.model = dm,
                          name = "new_att",
                          type = "character",
                          default.val = NA,
                          default.fun = NA,
                          skip = FALSE,
                          filter = NULL)

  # -- checks:
  expect_output(str(res), "data.frame")

  # -- check: output dim
  expect_equal(dim(res), c(5,6))

})
