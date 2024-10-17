

test_that("add_attribute works", {

  # -- test:
  x <- add_attribute(data.model = dm,
                     name = "new_att",
                     type = "character",
                     default.val = NA,
                     default.fun = NA,
                     skip = FALSE,
                     filter = FALSE)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(dim(dm)[1] + 1, length(DATA_MODEL_COLCLASSES)))

})


test_that("add_attribute: empty default.val", {

  # -- test:
  x <- add_attribute(data.model = dm,
                     name = "new_att",
                     type = "character",
                     default.val = "",
                     default.fun = NA,
                     skip = FALSE,
                     filter = FALSE)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(dim(dm)[1] + 1, length(DATA_MODEL_COLCLASSES)))

})


test_that("add_attribute: empty default.fun", {

  # -- test:
  x <- add_attribute(data.model = dm,
                     name = "new_att",
                     type = "character",
                     default.val = NA,
                     default.fun = "",
                     skip = FALSE,
                     filter = FALSE)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(dim(dm)[1] + 1, length(DATA_MODEL_COLCLASSES)))

})


test_that("add_attribute: skip NULL", {

  # -- test:
  x <- add_attribute(data.model = dm,
                     name = "new_att",
                     type = "character",
                     default.val = NA,
                     default.fun = NA,
                     skip = NULL,
                     filter = FALSE)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(dim(dm)[1] + 1, length(DATA_MODEL_COLCLASSES)))

})


test_that("add_attribute: filter NULL", {

  # -- test:
  x <- add_attribute(data.model = dm,
                     name = "new_att",
                     type = "character",
                     default.val = NA,
                     default.fun = NA,
                     skip = FALSE,
                     filter = NULL)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(dim(dm)[1] + 1, length(DATA_MODEL_COLCLASSES)))

})
