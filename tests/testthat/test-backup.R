
# -- test data
# need config & item files
create_testdata()


test_that("backup data.model works", {

  # -- simulate dm file (dummy content)
  saveRDS(TRUE, file = name(module_id, what = "dm", url = T))

  # -- function call
  # create first backup
  backup(id = module_id, type = "dm", max = 1)

  # -- check
  x <- list.files(path = file.path(testdata_path_base, "backup"), pattern = name(module_id, what = "dm"))
  expect_length(x, 1)

})


test_that("backup config works", {

  # -- backup
  backup(id = module_id, type = "config", max = 1)

  # -- check
  x <- list.files(path = file.path(testdata_path_base, "backup"), pattern = name(what = "config"))
  expect_length(x, 1)

})


test_that("backup items works", {

  # -- create first backup
  backup(id = module_id, type = "items", max = 1)

  # -- check
  x <- list.files(path = file.path(testdata_path_base, "backup"), pattern = name(module_id))
  expect_length(x, 1)

  # -- simulate old files
  # 1 remaining from above test
  backup(id = module_id, type = "items", max = 3)
  Sys.sleep(1)
  backup(id = module_id, type = "items", max = 3)
  Sys.sleep(1)
  backup(id = module_id, type = "items", max = 3)

  # -- check
  x <- list.files(path = file.path(testdata_path_base, "backup"), pattern = name(module_id))
  expect_length(x, 3)

  # -- reduce max
  # 2 files should be deleted
  backup(id = module_id, type = "items", max = 1)

  # -- check
  x <- list.files(path = file.path(testdata_path_base, "backup"), pattern = name(module_id))
  expect_length(x, 1)

})

# --clean
clean_all()
