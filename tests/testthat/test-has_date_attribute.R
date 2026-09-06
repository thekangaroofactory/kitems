

test_that("has_date_attribute works", {

  # baseline
  x <- c_create(project = "test") |> ci_append(ci_create(id = "foo"))
  expect_false(has_date_attribute(x, item = "foo"))

  # add date attribute
  x <- x |> ca_append(item = "foo", ca_create(name = "date", type = "Date"))
  expect_true(has_date_attribute(x, item = "foo"))

})
