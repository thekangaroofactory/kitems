

# --------------------------------------------------------------------------
# Scenario: create item
# --------------------------------------------------------------------------

test_that("Create item [trigger error]", {

  # -- declare arguments
  params <- list(id = module_id,
                 trigger = "dummy")

  # -- module server call
  expect_error(testServer(kitems, args = params))

})
