

# -- setup
create_testdata()


# --------------------------------------------------------------------------
# Scenario: select data model attribute
# --------------------------------------------------------------------------

test_that("Select data model attribute works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: select data model attribute")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitems_server, args = params, {

    # -- click
    session$setInputs('admin-data_model_rows_selected' = 1)

    # --------------------------------------------------------------------------
    # Data model (dummy check)
    # --------------------------------------------------------------------------

    # -- test class
    expect_equal(input$'admin-data_model_rows_selected', 1)

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
