

test_that("form works", {

  # -- baseline
  x <- config |>
    yaml_to_dm(item = "foo", "name", "type", "default", "values") |>
    default() |>
    form()

  expect_type(x, "list")

})
