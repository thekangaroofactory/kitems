

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
  testServer(kitemsManager_Server, args = params, {

    # -- click
    session$setInputs(data_model_rows_selected = 1)

    # --------------------------------------------------------------------------
    # Data model (dummy check)
    # --------------------------------------------------------------------------

    # -- check
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
