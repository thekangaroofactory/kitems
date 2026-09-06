

test_that("is_attribute works", {

  # -- baseline
  config <- c_create(project = "test") |> ci_append(ci_create(id = "foo"))

  # -- tests
  expect_true(is_attribute(config, item = "foo", attribute = "id"))
  expect_false(is_attribute(config, item = "foo", attribute = "dummy"))

})
