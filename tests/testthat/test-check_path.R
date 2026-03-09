

test_that("check_path works", {

  # -- no error (return NULL)
  expect_null(check_path(getwd()))

  # -- NULL
  expect_error(check_path(NULL), "path can't be NULL, set R_KITEMS_PATH environment variable")

  # -- empty
  expect_error(check_path(""), "path is empty, set R_KITEMS_PATH environment variable")

  # -- not exist
  expect_error(check_path("./dummy", "path does not exist, check R_KITEMS_PATH environment variable"))

})
