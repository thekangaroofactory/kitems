
# -- setup
create_testdata()

# -- test
test_that("backup data.model works", {

  # -- function call
  # create first backup
  backup(id = module_id, type = "dm", path = testdata_path, max = 1)

  # -- check
  url <- file.path(testdata_path, "backup", paste0(dm_name(module_id), "_", as.character(Sys.Date()), ".rds"))
  expect_true(file.exists(url))

  # -- simulate old files
  # 3 files in backup folder
  file.copy(url, file.path(testdata_path, "backup", paste0(dm_name(module_id), "_", as.character(Sys.Date() - 1), ".rds")))
  file.copy(url, file.path(testdata_path, "backup", paste0(dm_name(module_id), "_", as.character(Sys.Date() - 2), ".rds")))

  # -- function call
  # first backup will be overwritten
  backup(id = module_id, type = "dm", path = testdata_path, max = 3)

  # -- check
  n <- length(list.files(path = file.path(testdata_path, "backup"), pattern = dm_name(module_id)))
  expect_equal(n, 3)

  # -- function call
  # 2 files should be deleted
  backup(id = module_id, type = "dm", path = testdata_path, max = 1)

  # -- check
  n <- length(list.files(path = file.path(testdata_path, "backup"), pattern = dm_name(module_id)))
  expect_equal(n, 1)

})

# -- test
test_that("backup items works", {

  # -- function call
  # create first backup
  backup(id = module_id, type = "items", path = testdata_path, max = 1)

  # -- check
  url <- file.path(testdata_path, "backup", paste0(items_name(module_id), "_", as.character(Sys.Date()), ".csv"))
  expect_true(file.exists(url))

  # -- simulate old files
  # 3 files in backup folder
  file.copy(url, file.path(testdata_path, "backup", paste0(items_name(module_id), "_", as.character(Sys.Date() - 1), ".csv")))
  file.copy(url, file.path(testdata_path, "backup", paste0(items_name(module_id), "_", as.character(Sys.Date() - 2), ".csv")))

  # -- function call
  # first backup will be overwritten
  backup(id = module_id, type = "items", path = testdata_path, max = 3)

  # -- check
  n <- length(list.files(path = file.path(testdata_path, "backup"), pattern = items_name(module_id)))
  expect_equal(n, 3)

  # -- function call
  # 2 files should be deleted
  backup(id = module_id, type = "items", path = testdata_path, max = 1)

  # -- check
  n <- length(list.files(path = file.path(testdata_path, "backup"), pattern = items_name(module_id)))
  expect_equal(n, 1)

})

# --clean
clean_all()
