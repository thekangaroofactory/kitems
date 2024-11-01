

# -- Setup
create_testdata()


# -- Scenario:
test_that("Shortcut works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: Shortcut")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = FALSE,
                 shortcut = TRUE)

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
clean_all(testdata_path)
