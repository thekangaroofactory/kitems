
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
# Scenario:
# --------------------------------------------------------------------------

test_that("Filter with multiple conditions works", {

  # -- declare arguments
  params <- list(id = module_id,
                 autosave = TRUE,
                 filter = reactiveVal(kitems::filter_event(layer = "main", name == "Banana", isvalid == FALSE)))

  # -- module server call
  testServer(kitems, args = params, {

    # -- flush
    session$flushReact()

    # -- checks
    expect_true(all(filtered_items()$name == "Banana"))
    expect_true(all(filtered_items()$isvalid == FALSE))

  })

})

# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
