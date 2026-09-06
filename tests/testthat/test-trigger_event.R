

test_that("trigger_event works", {

  # -- baseline
  x <- trigger_event()
  expect_type(x, "list")

  # -- error
  expect_error(trigger_event(workflow = "update", type = "dialog"))

  # -- with values
  x <- trigger_event(workflow = "create", type = "dialog", values = list(name = "xxx"))
  expect_type(x, "list")
  expect_identical(names(x), c("event_id", "workflow", "type", "values"))

})
