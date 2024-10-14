

test_that("dm_check_integrity", {

  # -- function call
  x <- dm_check_integrity(data.model = dm, items = items, template = NULL)

  # -- check
  expect_true(x)

})


test_that("dm_check_integrity: extra attribute in items", {

  # -- function call
  x <- dm_check_integrity(data.model = dm, items = items_extra_att, template = NULL)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: x dim
  expect_equal(dim(x), c(dim(dm)[1] + 1, length(DATA_MODEL_COLCLASSES)))

})


test_that("dm_check_integrity: missing id", {

  # -- function call
  x <- dm_check_integrity(data.model = dm[dm$name != "id", ], items = items, template = TEMPLATE_DATA_MODEL)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: x dim
  expect_equal(dim(x), dim(dm))

  # -- check: id params
  expect_equal(x[x$name == "id", ]$default.fun, TEMPLATE_DATA_MODEL[TEMPLATE_DATA_MODEL$name == "id", ]$default.fun)
  expect_true(x[x$name == "id", ]$skip)
  expect_true(x[x$name == "id", ]$filter)

})


test_that("dm_check_integrity: extra attribute in data model", {

  # -- function call
  x <- dm_check_integrity(data.model = dm_extra_att, items = items, template = NULL)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: x dim
  expect_equal(dim(x), c(dim(dm_extra_att)[1] - 1, length(DATA_MODEL_COLCLASSES)))

})


test_that("dm_check_integrity: migrate data model", {

  # -- alter data model
  dm$default.arg <- NULL

  # -- function call
  x <- dm_check_integrity(data.model = dm, items = items, template = NULL)

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: x dim
  expect_equal(dim(x), c(dim(dm)[1], length(DATA_MODEL_COLCLASSES)))

})

