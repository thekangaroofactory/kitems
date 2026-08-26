
create_folder()

test_that("Verb amend works", {

  # -- build baseline
  config <- design(project = "test",
                    item = "foo") |>
     extend(item = "foo",
            attribute = c(name = "total", type = "integer"))

  # -- single instruction
  x <- config |>
    amend(item = "foo", attribute = c(name = "total", default = 12))
  expect_identical(config_extract(x, item = "foo", attribute = "total")$default, "12")

  # -- multiple instructions
  x <- config |>
    amend(item = "foo",
          attribute = c(name = "total", values = "suggest(12)"),
          attribute = c(name = "total", default = "0"))
  expect_identical(names(config_extract(x, item = "foo", attribute = "total")), c("name", "type", "values", "default"))

})

clean_all()
