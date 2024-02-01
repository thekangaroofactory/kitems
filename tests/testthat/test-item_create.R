

test_that("item_create", {

  # -- function call
  x <- item_create(values = values, data.model = dm)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(1, length(colClasses)))

  # -- test logical: #176
  expect_false(x$isvalid)

})


test_that("item_create works with NULL value", {

  # -- function call
  x <- item_create(values = list("id" = c(170539948621),
                                 "date" = c(as.Date("2024-01-25", origin = "01-01-1970")),
                                 "name" = NULL,
                                 "quantity" = 4,
                                 "total" = "78.9",
                                 "isvalid" = c(FALSE)), data.model = dm)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(1, length(colClasses)))

  # -- test logical: #176
  expect_false(x$isvalid)

})
