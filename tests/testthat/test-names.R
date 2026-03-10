

test_that("kitems_names works", {

  # -- check names
  expect_equal(dm_name(module_id), paste0(module_id, "_data_model"))
  expect_equal(items_name(module_id), paste0(module_id, "_items"))

  # -- check URLs
  expect_equal(dm_url(module_id, testdata_path), file.path(testdata_path, paste0(dm_name(module_id), ".rds")))
  expect_equal(items_url(module_id, testdata_path), file.path(testdata_path, paste0(items_name(module_id), ".csv")))

})
