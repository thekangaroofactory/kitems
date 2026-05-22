

# -- case default ---------------------------------------------------------------
test_that("item_form: create", {

  # -- function call
  x <- dm_no_skip |>
    dm_default() |>
    item_form(ns = shiny::NS("id"))

  # -- check class
  expect_type(x, "list")

})


# -- case all attributes are skipped -------------------------------------------
test_that("item_form: only id", {

  # -- function call
  x <- dm_id_only |>
    dplyr::filter(!skip) |>
    dm_default() |>
    item_form(ns = shiny::NS("id"))

  # -- check class
  expect_null(x)

})


# -- case logical without default ----------------------------------------------
test_that("item_form: logical without default", {

  # -- function call
  x <- attribute_create(data.model = NULL, name = "isValid", class = "logical") |>
    dm_default() |>
    item_form(ns = shiny::NS("id"))

  # -- check class
  expect_type(x, "list")

})
