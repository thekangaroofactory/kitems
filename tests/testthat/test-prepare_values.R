

test_that("prepare_values works", {

  # -- baseline
  x <- prepare_values(values = list(quantity = 12), config, item = "foo")
  expect_s3_class(x, "data.frame")
  expect_identical(nrow(x), 1L)
  expect_identical(names(x), c_attributes(config, item = "foo"))

  # -- make rectangular
  x <- prepare_values(values = list(quantity = c(1, 2), name = "xxx"), config, item = "foo")
  expect_s3_class(x, "data.frame")
  expect_identical(nrow(x), 2L)
  expect_identical(names(x), c_attributes(config, item = "foo"))
  expect_identical(x$name, c("xxx", "xxx"))

  # -- refresh
  # need an attribute that is skipped & refreshed on update
  config_2 <- c_create(project = "test") |>
    ci_append(ci_create(id = "foo")) |>
    ca_append(item = "foo",
              ca_create(name = "created", type = "POSIXct", default = "Sys.time()")) |>
    ca_behavior(item = "foo", behavior = "skip", "created") |>
    ca_behavior(item = "foo", behavior = "refresh", "created")
  # call
  # don't need no value, 'created' should be added
  x <- prepare_values(values = list(), config_2, item = "foo", update = TRUE)
  # tests
  expect_type(x, "list")
  expect_length(x, 1)
  expect_identical(names(x), ci_behavior(config_2, item = "foo", behavior = "refresh"))



})
