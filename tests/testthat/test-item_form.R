

test_that("item_form works", {

  # -- baseline
  x <- config |>
    yaml_to_dm(item = "foo", "name", "type", "default", "values") |>
    default() |>
    item_form(ns = shiny::NS("id"))

  expect_type(x, "list")

})
