

test_that("Core item works", {

  # -- create
  x <- ci_create(id = "foo", description = "test")
  expect_type(x, "list")
  expect_identical(names(x), c("id", "description", "source", "data.model"))

  # -- non char id
  expect_warning(x <- ci_create(id = 12))
  expect_null(x)

  # -- append (multiple)
  config <- c_create(project = "test")
  config <- ci_append(config, ci_create(id = "foo"), ci_create(id = "bar", description = "test"))
  expect_identical(c_items(config), c("foo", "bar"))

  # -- position
  expect_identical(ci_position(config, item = "bar"), 2L)

  # -- move
  config <- ci_move(config, item = "bar", where = list(position = "before", item = "foo"))
  expect_identical(c_items(config), c("bar", "foo"))

  # -- classes
  expect_identical(ci_classes(config, "foo"), c(id = "numeric"))

  # -- behaviors
  expect_identical(ci_behavior(config, item = "foo"), "id")
  expect_null(ci_behavior(config, item = "foo", behavior = "refresh"))
  expect_identical(ci_behavior(config, item = "foo", behavior = "hide"), "id")

  # -- connector
  x <- ci_connector(config, item = "foo")
  expect_type(x, "list")
  expect_identical(names(x), c("type", "path", "filename"))

  # -- row order (not set yet)
  expect_null(ci_row_order(config, item = "foo"))
  config <- ci_sort(config, item = "foo", sort = "id")
  expect_identical(ci_row_order(config, item = "foo"), "id")

  # -- drop
  config <- ci_drop(config, item = "foo")
  expect_identical(c_items(config), "bar")

})
