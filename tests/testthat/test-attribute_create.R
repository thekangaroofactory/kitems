

test_that("attribute_create works", {

  # -- test:
  x <- attribute_create(data.model = dm, name = "new_att", class = "character")

  # -- checks:
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(dim(dm)[1] + 1, length(DATA_MODEL_COLCLASSES)))

})


test_that("attribute_create: class.arg", {

  # -- test:
  x <- attribute_create(data.model = dm,
                        name = "new_att",
                        class = "POSIXct",
                        class.arg = "list(format = '%Y-%m-%dT%H:%M:%S')")

  # -- checks:
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(dim(dm)[1] + 1, length(DATA_MODEL_COLCLASSES)))

})
