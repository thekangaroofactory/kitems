

test_that("dm_inputs_ui / create works", {

  # -- function call
  x <- dm_inputs_ui(names = NULL, types = NULL, ns = shiny::NS())

  # -- check
  expect_equal(class(x), c("shiny.render.function", "function"))


})


test_that("dm_inputs_ui / update id works", {

  # -- function call
  x <- dm_inputs_ui(update = TRUE, attribute = dm[dm$name == "id", ], ns = shiny::NS())

  # -- check
  expect_equal(class(x), c("shiny.render.function", "function"))


})


test_that("dm_inputs_ui / update works", {

  # -- function call
  x <- dm_inputs_ui(update = TRUE, attribute = dm[dm$name == "total", ], ns = shiny::NS())

  # -- check
  expect_equal(class(x), c("shiny.render.function", "function"))


})
