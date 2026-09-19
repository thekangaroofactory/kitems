

test_that("Core config works", {

  # -- create
  x <- c_create(project = "dummy")
  expect_type(x, "list")
  expect_identical(x$version, as.character(packageVersion("kitems")))

  # -- items
  x <- c_items(config)
  expect_identical(x, "foo")

  # -- attributes
  x <- c_attributes(config, item)
  expect_identical(x, c("id", "quantity", "total", "name", "date", "isvalid", "created"))

  # -- extract
  x <- c_extract(config, item)
  expect_type(x, "list")
  expect_identical(names(x), c("id", "source", "data.model"))

  x <- c_extract(config, item, attribute = "total")
  expect_type(x, "list")
  expect_true(all(c("name", "type") %in% names(x)))

})
