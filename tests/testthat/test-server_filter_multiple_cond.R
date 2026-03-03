
# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()

# --------------------------------------------------------------------------
# Scenario:
# --------------------------------------------------------------------------

test_that("Filter with multiple conditions works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 autosave = TRUE,
                 filter = reactiveVal(kitems::filter_event(layer = "pre", name == "Banana", total == 106)))

  # -- module server call
  testServer(kitems, args = params, {

    # -- flush
    session$flushReact()

    # -- checks
    expect_true(all(prefiltered_items()$name == "Banana"))
    expect_true(all(prefiltered_items()$total == 106))

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
