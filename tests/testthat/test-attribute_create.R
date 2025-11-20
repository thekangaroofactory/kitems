

test_that("attribute_create works", {

  # -- test:
  x <- attribute_create(data.model = dm,
                        name = "new_att",
                        type = "character",
                        default.val = NA,
                        default.fun = NA,
                        skip = FALSE,
                        display = FALSE)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(dim(dm)[1] + 1, length(DATA_MODEL_COLCLASSES)))

})


test_that("attribute_create: empty default.val", {

  # -- test:
  x <- attribute_create(data.model = dm,
                        name = "new_att",
                        type = "character",
                        default.val = "",
                        default.fun = NA,
                        skip = FALSE,
                        display = FALSE)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(dim(dm)[1] + 1, length(DATA_MODEL_COLCLASSES)))

})


test_that("attribute_create: empty default.fun", {

  # -- test:
  x <- attribute_create(data.model = dm,
                        name = "new_att",
                        type = "character",
                        default.val = NA,
                        default.fun = "",
                        skip = FALSE,
                        display = FALSE)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(dim(dm)[1] + 1, length(DATA_MODEL_COLCLASSES)))

})


test_that("attribute_create: skip NULL", {

  # -- test:
  x <- attribute_create(data.model = dm,
                        name = "new_att",
                        type = "character",
                        default.val = NA,
                        default.fun = NA,
                        skip = NULL,
                        display = FALSE)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(dim(dm)[1] + 1, length(DATA_MODEL_COLCLASSES)))

})


test_that("attribute_create: display NULL", {

  # -- test:
  x <- attribute_create(data.model = dm,
                        name = "new_att",
                        type = "character",
                        default.val = NA,
                        default.fun = NA,
                        skip = FALSE,
                        display = NULL)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: output dim
  expect_equal(dim(x), c(dim(dm)[1] + 1, length(DATA_MODEL_COLCLASSES)))

})
