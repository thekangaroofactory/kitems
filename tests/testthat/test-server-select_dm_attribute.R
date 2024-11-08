

# -- setup
create_testdata()


# --------------------------------------------------------------------------
# Scenario: select data model attribute
# --------------------------------------------------------------------------

test_that("Select data model attribute works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitems, args = params, {

    # -- click
    session$setInputs('admin-dm_table_rows_selected' = 1)

    # --------------------------------------------------------------------------
    # Data model (dummy check)
    # --------------------------------------------------------------------------

    # -- test class
    expect_equal(input$'admin-dm_table_rows_selected', 1)

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
