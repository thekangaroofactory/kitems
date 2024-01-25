

test_that("item_save works", {

  # -- function call
  item_save(data = items, file = test_file_output, path = path_test_output)

  # -- check file exists
  expect_true(file.exists(file.path(path_test_output, test_file_output)))

  # -- cleanup file & folder
  unlink(file.path(path_test_output, test_file_output))
  unlink(path_test_output, recursive = TRUE)

})
