
# -- case: multiple items with list of values (same length elements)
test_that("item_create multiple items works", {

  # -- function call
  values <-  list("id" = c(170539948621, 170539948622),
                  "date" = c(Sys.Date(), Sys.Date()),
                  "name" = c("name_1", "name_2"),
                  "quantity" = c(4, 5),
                  "total" = c(78.9, 80.6),
                  "isvalid" = c(FALSE, TRUE))

  # -- function call
  x <- item_create(values, data.model = dm)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(2, length(colClasses)))

  # -- test date
  expect_true(inherits(x$date, "POSIXct"))

})


# -- case: multiple items with list of values (different length elements)
test_that("item_create multiple items works", {

  # -- function call
  values <-  list("id" = c(170539948621, 170539948622),
                  "date" = Sys.Date(),
                  "name" = c("name_1", NA),
                  "quantity" = c(4, 5),
                  "total" = c(78.9, 12),
                  "isvalid" = FALSE)

  # -- function call
  x <- item_create(values, data.model = dm)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(2, length(colClasses)))

  # -- test date
  expect_true(inherits(x$date, "POSIXct"))

})
