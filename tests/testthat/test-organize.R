

test_that("Grammar organize works", {

  # baseline
  config <- design(project = "test", item = "foo") |>
    extend(item = "foo",
           attribute = c(name = "total", type = "integer"))

  # test
  expect_no_warning(x <- organize(config, item = "foo", sort = "total"))
  expect_identical(organized(x, item = "foo"), "total")

})
