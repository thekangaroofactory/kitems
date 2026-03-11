

# -- setup
create_integrity_testdata()


# --------------------------------------------------------------------------
# Scenario: data model integrity
# --------------------------------------------------------------------------

test_that("Data model integrity works", {

  # -- declare arguments
  params <- list(id = module_id)

  # -- module server call
  expect_error(testServer(kitems, args = params))

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
