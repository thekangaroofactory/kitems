

test_that("dm_default works", {

  # -- baseline
  x <- dm_default(data.model = yaml_to_dm(config, item = "foo", "name", "type", "default", "values"))
  expect_s3_class(x, "data.frame")
  expect_identical(x$name, c_attributes(config, item = "foo"))

  # -- update baseline
  config_2 <- config |> amend(item = "foo",
                              attribute = c(name = "quantity", default = "0"),
                              attribute = c(name = "total", default = "0.5"),
                              attribute = c(name = "name", default = "doe"),
                              attribute = c(name = "date", default = "Sys.Date()"),
                              attribute = c(name = "isvalid", default = "TRUE"),
                              attribute = c(name = "created", default = "Sys.time()"))

  # -- check
  expect_no_condition(x <- dm_default(data.model = yaml_to_dm(config_2, item = "foo", "name", "type", "default", "values")))
  expect_s3_class(x, "data.frame")
  expect_identical(x$name, c_attributes(config_2, item = "foo"))
  expect_identical(x$type, unname(ci_classes(config_2, item = "foo")))

})
