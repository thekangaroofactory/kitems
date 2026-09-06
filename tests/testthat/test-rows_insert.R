

test_that("rows_insert works", {

  # ////////////////////////////////////////////////////////////////////////////
  # Main cases

  # -- insert single item
  x <- list(name = "create", total = 200) |>
    prepare_values(config, item = "foo") |>
    rows_insert(items)

  expect_s3_class(x, "data.frame")
  expect_equal(nrow(x), nrow(items) + 1)
  expect_equal(x$name[nrow(x)], "create")
  expect_equal(x$total[nrow(x)], 200)

  # -- insert multiple items
  x <- list(name = c("new_1", "new_2"), total = c(100, 200)) |>
    prepare_values(config, item = "foo") |>
    attribute_values(data.model = dm) |>
    rows_insert(items)

  expect_s3_class(x, "data.frame")
  expect_false(any(duplicated(x$id)))
  expect_equal(dim(x), dim(items) + c(2, 0))
  expect_equal(x$name[nrow(x) - 1], "new_1")
  expect_equal(x$total[nrow(x) - 1], 100)
  expect_equal(x$name[nrow(x)], "new_2")
  expect_equal(x$total[nrow(x)], 200)

  # -- create single item (items = NULL)
  x <- list(name = "create", total = 200) |>
    prepare_values(config, item = "foo") |>
    attribute_values(data.model = dm) |>
    rows_insert(items = data.frame())

  expect_s3_class(x, "data.frame")
  expect_equal(nrow(x), 1)
  expect_equal(x$name, "create")

  # -- create multiple items (items = NULL)
  x <- list(total = 1:10) |>
    prepare_values(config, item = "foo") |>
    attribute_values(data.model = dm) |>
    rows_insert(items = data.frame())

  expect_s3_class(x, "data.frame")
  expect_equal(nrow(x), 10)


  # ////////////////////////////////////////////////////////////////////////////
  # Specific cases coverage

  # -- drop unmatched columns
  x <- list(quantity = 100, dummy = "foo") |>
    prepare_values(config, item = "foo") |>
    attribute_values(data.model = dm) |>
    rows_insert(items = items)

  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), dim(items) + c(1, 0))

  # -- make rectangular
  x <- list(quantity = 100, total = c(1:4)) |>
    prepare_values(config, item = "foo") |>
    attribute_values(data.model = dm) |>
    rows_insert(items = items)

  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), dim(items) + c(4, 0))

  # -- NULL element
  x <- list(id = NULL, quantity = 100) |>
    prepare_values(config, item = "foo") |>
    attribute_values(data.model = dm) |>
    rows_insert(items = items)
  expect_equal(dim(x), dim(items) + c(1, 0))

})
