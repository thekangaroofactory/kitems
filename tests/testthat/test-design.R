
create_folder()

# -- test
test_that("Verb design works", {

  # -- create config
  config <- design(project = "test")
  expect_type(config, "list")
  expect_identical(config$version, as.character(packageVersion("kitems")))

  # -- create (single) item
  config <- design(project = "test",
                   item = "foo")
  expect_true("items" %in% names(config))
  expect_identical(length(config$items), 1L)
  expect_identical(config$items[[1]]$id, "foo")

  # -- add another item
  config <- config |> design(item = c(id = "bar", description = "x"))
  expect_identical(length(config$items), 2L)
  expect_identical(config$items[[2]]$description, "x")

  # -- create (multiple) items
  config <- design(project = "test",
                   item = "foo",
                   item = "bar")
  expect_identical(length(config$items), 2L)

  # -- create (multiple) items with description
  config <- design(project = "test",
                   item = c(id = "foo", description = "x"),
                   item = c(id = "bar", description = "z"))
  expect_identical(length(config$items), 2L)

  # -- create (multiple) items with or without description
  config <- design(project = "test",
                   item = c(id = "foo", description = "x"),
                   item = "bar")
  expect_identical(length(config$items), 2L)
  expect_null(config$items[[2]]$description)

  # -- create (single) attribute
  config <- config |>
    design(attribute = c(item = "foo", name = "value", type = "integer"))
  expect_true("attributes" %in% names(config$items[[1]]$data.model))
  expect_identical(length(config$items[[1]]$data.model$attributes), 2L)
  expect_true(all(c("name", "type") %in% names(config$items[[1]]$data.model$attributes[[1]])))

  # -- create (multiple) attributes
  config <- config |>
    design(attribute = c(item = "bar", name = "value", type = "integer"),
           attribute = c(item = "bar", name = "comment", type = "character"))
  expect_identical(length(config$items[[2]]$data.model$attributes), 3L)

})

clean_all()
