
create_folder()

test_that("has_date_attribute works", {

  # baseline
  x <- design(project = "test", item = "foo")
  expect_false(has_date_attribute(x, item = "foo"))

  # add date attribute
  x <- x |>extend(item = "foo", attribute = c(name = "date", type = "Date"))
  expect_true(has_date_attribute(x, item = "foo"))

})

clean_all()
