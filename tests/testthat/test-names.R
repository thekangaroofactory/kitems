

test_that("kitems_names works", {

  # -- function call
  x <- dm_name(module_id)

  # -- check
  expect_equal(x, paste0(module_id, "_data_model"))

  # -- function call
  x <- items_name(module_id)

})
