

# -- case default ---------------------------------------------------------------
test_that("item_form: create", {

  # -- function call
  x <- item_form(ns = ns, data.model = dm_no_skip)

  # -- check class
  expect_type(x, "list")

})


# -- case all attributes are skipped -------------------------------------------
test_that("item_form: only id", {

  # -- function call
  x <- item_form(ns = ns, data.model = dm_id_only)

  # -- check class
  expect_type(x, "character")

})


# -- case logical without default ----------------------------------------------
test_that("item_form: logical without default", {

  # -- function call
  x <- item_form(ns = ns, data.model = data_model(colClasses = c(isValid = "logical")))

  # -- check class
  expect_type(x, "list")

})


# -- case update ---------------------------------------------------------------
test_that("item_form: update", {

  # -- function call
  x <- item_form(ns = ns, item = items[1, ], update = TRUE, data.model = dm)

  # -- check class
  expect_type(x, "list")

})
