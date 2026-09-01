
# -- setup
create_testdata()

# -- test
test_that("backup data.model works", {

  # -- function call
  # create first backup
  backup(id = module_id, type = "dm", max = 1)

  # -- check
  x <- list.files(path = file.path(testdata_path, "backup"), pattern = name(module_id, what = "dm"))
  expect_length(x, 1)

  # -- simulate old files
  # 3 files in backup folder
  replicate(2,
            file.copy(x, file.path(testdata_path, "backup", name(module_id, what = "dm", file = T, backup = T))))

  # -- function call
  # first backup will be overwritten
  backup(id = module_id, type = "dm", max = 3)

  # -- check
  x <- list.files(path = file.path(testdata_path, "backup"), pattern = name(module_id, what = "dm"))
  expect_length(x, 3)

  # -- function call
  # 2 files should be deleted
  backup(id = module_id, type = "dm", max = 1)

  # -- check
  x <- list.files(path = file.path(testdata_path, "backup"), pattern = name(module_id, what = "dm"))
  expect_length(x, 1)

})

# -- test
test_that("backup items works", {

  # -- function call
  # create first backup
  backup(id = module_id, type = "items", max = 1)

  # -- check
  url <- list.files(path = file.path(testdata_path, "backup"), pattern = name(module_id))
  expect_true(file.exists(url))

  # -- simulate old files
  # 3 files in backup folder
  replicate(2,
            file.copy(url, file.path(testdata_path, "backup", name(module_id, file = T, backup = T))))

  # -- function call
  # first backup will be overwritten
  backup(id = module_id, type = "items", max = 3)

  # -- check
  x <- list.files(path = file.path(testdata_path, "backup"), pattern = name(module_id))
  expect_length(x, 3)

  # -- function call
  # 2 files should be deleted
  backup(id = module_id, type = "items", max = 1)

  # -- check
  x <- list.files(path = file.path(testdata_path, "backup"), pattern = name(module_id))
  expect_length(x, 1)

})

# --clean
clean_all()
