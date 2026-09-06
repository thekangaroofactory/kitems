

test_that("Core attribute works", {

  # -- baseline
  config <- c_create(project = "test") |> ci_append(ci_create(id = "foo"))

  # -- create
  x <- ca_create(name = "quantity", type = "integer")
  expect_type(x, "list")
  expect_identical(names(x), c("name", "type"))

  # -- append (multiple)
  config <- ca_append(config, item = "foo", x, ca_create(name = "note", type = "character"))
  expect_identical(c_attributes(config, item = "foo"), c("id", "quantity", "note"))

  # -- replace
  config <- ca_replace(config, item = "foo", ca_create(name = "note", type = "character", default = "xxx"))
  expect_identical(c_attributes(config, item = "foo"), c("id", "quantity", "note"))

  # -- position
  expect_identical(ca_position(config, item = "foo", attribute = "quantity"), 2L)

  # -- move
  config <- ca_move(config, item = "foo", attribute = "note", where = list(position = "after", attribute = "id"))
  expect_identical(c_attributes(config, item = "foo"), c("id", "note", "quantity"))

  # -- behavior (skip)
  config <- ca_behavior(config, item = "foo", behavior = "skip", "note")
  expect_identical(config$items[[1]]$data.model$skip, c("id", "note"))
  config <- ca_behavior(config, item = "foo", behavior = "skip", "note", set = FALSE)
  expect_identical(config$items[[1]]$data.model$skip, "id")

  # -- behavior (refresh)
  config <- ca_behavior(config, item = "foo", behavior = "skip", "note")
  config <- ca_behavior(config, item = "foo", behavior = "refresh", "note")
  expect_identical(config$items[[1]]$data.model$refresh, "note")
  config <- ca_behavior(config, item = "foo", behavior = "refresh", "note", set = FALSE)
  expect_null(config$items[[1]]$data.model$refresh)
  config <- ca_behavior(config, item = "foo", behavior = "skip", "note", set = FALSE)
  x <- ca_behavior(config, item = "foo", behavior = "refresh", "note")
  expect_identical(x, config)

  # -- drop
  config <- ca_drop(config, item = "foo", attribute = "note")
  expect_identical(c_attributes(config, item = "foo"), c("id", "quantity"))

})
