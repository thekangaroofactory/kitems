
# -- setup
create_testdata()

# -- test
test_that("restore data.model works", {

  # -- create backup & restore it
  backup(id = module_id, path = testdata_path, type = "dm", max = 1)
  restore(id = module_id, path = testdata_path, type = "dm")

  # -- check
  url <- file.path(testdata_path, paste0(dm_name(module_id), ".rds"))
  expect_true(file.exists(url))

  # -- check
  n <- length(list.files(path = testdata_path, pattern = dm_name(module_id)))
  expect_equal(n, 2)

})

# -- test
test_that("restore items works", {

  # -- function call
  # create first backup
  backup(id = module_id, type = "items", path = testdata_path, max = 1)
  restore(id = module_id, path = testdata_path, type = "items")

  # -- check
  url <- file.path(testdata_path, paste0(items_name(module_id), ".csv"))
  expect_true(file.exists(url))

  # -- check
  n <- length(list.files(path = testdata_path, pattern = items_name(module_id)))
  expect_equal(n, 2)

})

# --clean
clean_all(testdata_path)
