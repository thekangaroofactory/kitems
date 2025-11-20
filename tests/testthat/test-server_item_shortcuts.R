

# -- Setup
create_testdata()
ktools::trace_level(1)

# -- Scenario:
test_that("Shortcut works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 autosave = FALSE,
                 options = list(
                   shortcut = TRUE))

  # -- module server call
  testServer(kitems, args = params, {

    # -- click
    session$setInputs(item_create = 1)

    # -- click shortcut
    suggestion <- paste(module_id, paste("name", "Banana", sep = "_"), sep = "-")


    # --------------------------------------------------------------------------
    # Test
    # --------------------------------------------------------------------------

    # -- expects an output in the console
    expect_snapshot(session$setInputs(shortcut_trigger = "data-name_Banana"))


  })

})


# -- Cleanup
clean_all()
ktools::trace_level(0)
