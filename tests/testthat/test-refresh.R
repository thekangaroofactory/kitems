

test_that("Verb refresh works", {

  # baseline
  config <- design(project = "test", item = "foo") |>
    extend(item = "foo",
           attribute = c(name = "total", type = "integer")) |>
    skip(item = "foo", "total")

  # -- refresh & refreshed
  x <- config |> refresh(item = "foo", "total")
  expect_identical(x |> refreshed(item = "foo"), "total")

  # -- freeze & frozen
  x <- config |> freeze(item = "foo", "total")
  expect_identical(x |> frozen(item = "foo"), c("id", "total"))

})

clean_all()
