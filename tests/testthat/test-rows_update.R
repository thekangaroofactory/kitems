

test_that("rows_update works", {

  # ////////////////////////////////////////////////////////////////////////////
  # Main cases

  # -- update single item
  x <- list(id = items$id[1], name = "update", total = 200) |>
    prepare(config, item = "foo", update = TRUE) |>
    validate(data.model = dm, update = TRUE) |>
    rows_update(items)

  expect_equal(dim(x), dim(items))
  expect_equal(x$name[1], "update")
  expect_equal(x$total[1], 200)

  # -- update multiple items
  x <- list(id = items$id[1:2], name = "update", total = 200) |>
    prepare(config, item = "foo", update = TRUE) |>
    validate(data.model = dm, update = TRUE) |>
    rows_update(items)

  expect_equal(dim(x), dim(items))
  expect_equal(x$name[1], "update")
  expect_equal(x$total[1], 200)
  expect_equal(x$name[2], "update")
  expect_equal(x$total[2], 200)

  # -- force update skipped attribute
  # send the id only (will just refresh the skipped attribute)
  config_2 <- config |> skip(item = "foo", "date") |> refresh(item = "foo", "date")
  dm <- yaml_to_dm(config_2, item = "foo", "name", "type", "default", "class.arg")
  ref_date <- as.numeric(items$date[1])
  x <- list(id = items$id[1]) |>
    prepare(config, item = "foo", update = TRUE) |>
    validate(data.model = dm, update = TRUE) |>
    rows_update(items)

  expect_equal(dim(x), dim(items))
  expect_true(!identical(items$date[1], ref_date))

  # -- same with other attribute to update
  ref_date <- as.numeric(items$date[1])
  x <- list(id = items$id[2], total = 99) |>
    prepare(config, item = "foo", update = TRUE) |>
    validate(data.model = dm, update = TRUE) |>
    rows_update(items)

  expect_equal(dim(x), dim(items))
  expect_true(!identical(items$date[2], ref_date))
  expect_equal(x$total[2], 99)


  # ////////////////////////////////////////////////////////////////////////////
  # Specific cases coverage

  # -- drop unmatched columns
  x <- list(id = items$id[1], name = "update", dummy_col = "xxx") |>
    prepare(config, item = "foo", update = TRUE) |>
    validate(data.model = dm, update = TRUE) |>
    rows_update(items)

  expect_equal(dim(x), dim(items))

  # -- make rectangular
  x <- list(id = items$id, quantity = 100, total = c(1:4)) |>
    prepare(config, item = "foo", update = TRUE) |>
    validate(data.model = dm, update = TRUE) |>
    rows_update(items)

  expect_equal(dim(x), dim(items))

  # -- drop unmatched rows
  x <- list(id = 123, quantity = 100) |>
    prepare(config, item = "foo", update = TRUE) |>
    validate(data.model = dm, update = TRUE) |>
    rows_update(items)

  expect_equal(dim(x), dim(items))

})
