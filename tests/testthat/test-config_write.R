

test_that("config_write works", {

  config_write(config)
  expect_true(file.exists(name(module_id, what = "config", url = T)))

})

clean_all()
