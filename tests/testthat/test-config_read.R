

test_that("config_read works", {

  # -- no config file
  expect_null(config_read())

  # -- baseline
  create_testdata()
  expect_type(config_read(), "list")

})

clean_all()
