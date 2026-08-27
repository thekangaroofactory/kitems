
create_folder()

test_that("Verb shrink works", {

  # baseline
  config <- design(project = "test",
                   item = "foo") |>
    extend(item = "foo",
           attribute = c(name = "total", type = "integer"))

  # drop item
  x <- config |>
    shrink(item = "foo")
  expect_identical(x$items, list())

  # drop attribute
  x <- config |>
    shrink(attribute = c(item = "foo", name = "total"))
  expect_identical(config_attributes(x, item = "foo"), "id")

  # multiple instructions
  x <- config |>
    shrink(attribute = c(item = "foo", name = "total"),
           item = "foo")
  expect_identical(x$items, list())

  # missing item
  expect_warning(x <- config |> shrink(item = "dummy"))
  expect_identical(x, config)

  # missing attribute
  expect_warning(x <- config |>
                   shrink(attribute = c(item = "foo", name = "dummy")))
  expect_identical(x, config)

  # both missing
  # 2 warnings!
  expect_warning(
    expect_warning(x <- config |>
                     shrink(attribute = c(item = "dummy", name = "dummy"))))
  expect_identical(x, config)

})

clean_all()
