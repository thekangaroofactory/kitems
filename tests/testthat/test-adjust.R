

test_that("adjust works", {

  # -- baseline
  config_2 <- config |>
    ci_sort(item = "foo", sort = "desc(quantity)")

  # -- test
  x <- items |> adjust(config_2, item = "foo")
  expect_s3_class(x, "data.frame")
  expect_identical(x$quantity, sort(items$quantity, decreasing = T))

})
