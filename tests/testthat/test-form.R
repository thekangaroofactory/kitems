

test_that("form works", {

  # -- baseline
  x <- config |>
    yaml_to_dm(item = "foo", "name", "type", "default", "values") |>
    default() |>
    form(ns = shiny::NS("id"))

  expect_type(x, "list")

})
