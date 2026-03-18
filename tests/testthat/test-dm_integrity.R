

test_that("dm_integrity (check)",
          expect_true(dm_integrity(data.model = dm, items = items, template = NULL)))


test_that("dm_integrity (fix)",
          expect_true(dm_integrity(data.model = dm, items = items, template = NULL, fix = TRUE)))


test_that("dm_integrity: missing attribute (check)",
          expect_error(dm_integrity(data.model = dm, items = items_extra_att, template = NULL)))


test_that("dm_integrity: missing attribute (fix)", {

  # -- function call
  x <- dm_integrity(data.model = dm, items = items_extra_att, template = NULL, fix = TRUE)

  # -- checks:
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(dim(dm)[1] + 1, length(DATA_MODEL_COLCLASSES)))

})


test_that("dm_integrity: missing id (check)",
          expect_error(dm_integrity(data.model = dm[dm$name != "id", ], items = items, template = TEMPLATE_ATTRIBUTES)))


test_that("dm_integrity: missing id (fix)", {

  # -- function call
  x <- dm_integrity(data.model = dm[dm$name != "id", ], items = items, template = TEMPLATE_ATTRIBUTES, fix = TRUE)

  # -- checks:
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), dim(dm))
  expect_equal(x[x$name == "id", ]$default.fun, TEMPLATE_ATTRIBUTES[TEMPLATE_ATTRIBUTES$name == "id", ]$default.fun)
  expect_true(x[x$name == "id", ]$skip)
  expect_false(x[x$name == "id", ]$display)

})


test_that("dm_integrity: extra attribute (check)",
          expect_error(dm_integrity(data.model = dm_extra_att, items = items, template = NULL)))


test_that("dm_integrity: extra attribute (fix)", {

  # -- function call
  x <- dm_integrity(data.model = dm_extra_att, items = items, template = NULL, fix = TRUE)

  # -- checks:
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(dim(dm_extra_att)[1] - 1, length(DATA_MODEL_COLCLASSES)))

})

