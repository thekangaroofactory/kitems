

test_that("inputList: create", {

  # -- init
  ns <- shiny::NS("id")

  # -- function call
  x <- inputList(ns = ns, data.model = dm)

  # -- check class
  expect_type(x, "list")

})


test_that("inputList: update", {

  # -- init
  ns <- shiny::NS("id")

  # -- function call
  x <- inputList(ns = ns, item = items[1, ], update = TRUE, data.model = dm)

  # -- check class
  expect_type(x, "list")

})
