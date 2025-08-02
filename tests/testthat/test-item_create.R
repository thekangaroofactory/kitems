

test_that("item_create works", {

  # -- function call
  x <- item_create(values = values, data.model = dm)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(1, length(colClasses)))

  # -- test logical: #176
  expect_false(x$isvalid)

})


test_that("item_create fails with missing value", {

  # -- init
  values <- list("id" = c(170539948621),
                 "date" = c(as.Date("2024-01-25", origin = "01-01-1970")),
                 "quantity" = 4,
                 "total" = "78.9",
                 "isvalid" = c(FALSE))

  # -- function call
  expect_warning(item_create(values, data.model = dm))

})


# -- adding coverage #428
test_that("item_create works with length(0) value", {

  # -- function call
  values <-  list("id" = c(170539948621),
                  "date" = as.Date(numeric(0)),
                  "name" = "name",
                  "quantity" = 4,
                  "total" = "78.9",
                  "isvalid" = c(FALSE))

  # -- function call
  x <- item_create(values, data.model = dm)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(1, length(colClasses)))

  # -- test logical: #176
  expect_false(x$isvalid)
  expect_true(inherits(x$date, "POSIXct"))

})
