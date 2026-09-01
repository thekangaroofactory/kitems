
# -- setup
create_testdata()

# -- test
test_that("restore data.model works", {

  # -- create backup & restore it
  backup(id = module_id, type = "dm", max = 1)
  restore(id = module_id, type = "dm")

  # -- check
  n <- length(list.files(path = testdata_path, pattern = name(module_id, what = "dm")))
  expect_equal(n, 2)

})

# -- test
test_that("restore items works", {

  # -- function call
  # create first backup
  backup(id = module_id, type = "items", max = 1)
  restore(id = module_id, type = "items")

  # -- check
  url <- file.path(testdata_path, name(module_id, file = T))
  expect_true(file.exists(url))

  # -- check
  n <- length(list.files(path = testdata_path, pattern = name(module_id)))
  expect_equal(n, 2)

})

# --clean
clean_all()
