

test_that("kitems_names works", {

  # -- function call
  x <- dm_name(module_id)

  # -- check
  expect_equal(x, paste0(module_id, "_data_model"))

  # -- function call
  x <- items_name(module_id)

  # -- check
  expect_equal(x, paste0(module_id, "_items"))

  # -- function call
  x <- filter_date_name(module_id)

  # -- check
  expect_equal(x, paste0(module_id, "_filter_date"))

  # -- function call
  x <- trigger_add_name(module_id)

  # -- check
  expect_equal(x, paste0(module_id, "_trigger_add"))

  # -- function call
  x <- trigger_delete_name(module_id)

  # -- check
  expect_equal(x, paste0(module_id, "_trigger_delete"))

  # -- function call
  x <- trigger_save_name(module_id)

  # -- check
  expect_equal(x, paste0(module_id, "_trigger_save"))

  # -- function call
  x <- trigger_update_name(module_id)

  # -- check
  expect_equal(x, paste0(module_id, "_trigger_update"))

})
