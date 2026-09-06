

test_that("item_sort works", {

  # -- baseline
  config_2 <- config |>
    ci_sort(item = "foo", sort = "desc(quantity)")

  # -- test
  x <- items |> item_sort(config_2, item = "foo")
  expect_s3_class(x, "data.frame")
  expect_identical(x$quantity, sort(items$quantity, decreasing = T))

})
