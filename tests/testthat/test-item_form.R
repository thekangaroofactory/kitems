

# -- case default ---------------------------------------------------------------
test_that("item_form: create", {

  # -- function call
  x <- item_form(ns = ns, data.model = dm_default(dm_no_skip))

  # -- check class
  expect_type(x, "list")

})


# -- case all attributes are skipped -------------------------------------------
test_that("item_form: only id", {

  # -- function call
  x <- item_form(ns = ns, data.model = dm_default(dm_id_only))

  # -- check class
  expect_type(x, "character")

})


# -- case logical without default ----------------------------------------------
test_that("item_form: logical without default", {

  # -- function call
  x <- item_form(ns = ns, data.model = dm_default(attribute_create(data.model = NULL, name = "isValid", class = "logical")))

  # -- check class
  expect_type(x, "list")

})


# -- case update ---------------------------------------------------------------
test_that("item_form: update", {

  # -- function call
  x <- item_form(data.model = dm_default(dm), ns = ns)

  # -- check class
  expect_type(x, "list")

})
