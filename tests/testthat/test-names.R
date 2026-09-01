

test_that("kitems_names works", {

  # -- check names
  expect_type(name(module_id, what = "dm"), "character")
  expect_type(name(module_id), "character")

  # -- check URLs
  expect_type(name(module_id, file = T), "character")

})
