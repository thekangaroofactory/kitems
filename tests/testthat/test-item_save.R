

test_that("item_save works", {

  # -- function call
  item_save(data = items, file = "my_data.csv", path = testdata_path)

  # -- check file exists
  expect_true(file.exists(file.path(testdata_path, "my_data.csv")))

})

# -- cleanup data
clean_all(testdata_path)
