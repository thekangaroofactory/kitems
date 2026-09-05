

test_that("Grammar hide works", {

  # baseline
  config <- design(project = "test",
                   item = "foo") |>
    extend(item = "foo",
           attribute = c(name = "date", type = "Date"))

  # hide attribute
  expect_no_warning(config <- config |>
                      hide(item = "foo", "date"))

  # hidden attributes
  expect_identical(config |> hidden(item = "foo"), c("id", "date"))
  #'
  # display attribute
  expect_no_warning(config <- config |>
                      display(item = "foo", "date"))
  #'
  # displayed attributes
  expect_identical(config |> displayed(item = "foo"), "date")

})

clean_all()
