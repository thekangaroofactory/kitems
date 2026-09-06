

test_that("is_item works", {

  # -- baseline
  config <- c_create(project = "test") |> ci_append(ci_create(id = "foo"))

  # -- tests
  expect_true(is_item(config, item = "foo"))
  expect_false(is_item(config, item = "dummy"))

})
