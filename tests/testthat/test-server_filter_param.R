
# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()

# --------------------------------------------------------------------------
# Scenario: date sliderInput
# --------------------------------------------------------------------------

test_that("Filter reactive check works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 autosave = TRUE,
                 filter = 12)

  # -- module server call
  expect_error(testServer(kitems, args = params), "filter must be a reactive object")

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
