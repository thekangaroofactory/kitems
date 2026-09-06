

test_that("name works", {

  # -- dm
  expect_type(x <- name(module_id, what = "dm"), "character")
  expect_identical(x, "myitem_data_model")

  # -- item
  expect_type(x <- name(module_id), "character")
  expect_identical(x, "myitem_items")
  expect_type(x <- name(module_id, file = T), "character")
  expect_identical(x, "myitem_items.csv")
  expect_type(x <- name(module_id, url = T), "character")
  expect_identical(basename(x), "myitem_items.csv")
  expect_identical(dirname(x), testdata_path)

  # -- config
  expect_type(x <- name(module_id, what = "config", file = T), "character")
  expect_identical(x, "_kitems.yml")

  # -- backup
  expect_type(x <- name(module_id, backup = T), "character")
  expect_true(grepl(format(Sys.Date(), "%Y%m%d"), x))

})
