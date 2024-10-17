

# -- Create test data
create_noid_data_to_import()

# --------------------------------------------------------------------------
# Scenario: import data without id
# --------------------------------------------------------------------------

test_that("Import data without id works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: Import data without id works")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- click
    session$setInputs('admin-import_data' = 1)

    # -- create input value
    value <- data.frame(name = "data_to_import",
                        size = 12,
                        type = "dummy",
                        datapath = file.path(testdata_path, import_url))

    # -- set file input & click
    session$setInputs('admin-input_file' = value)
    session$setInputs('admin-confirm_import_file' = 1)

    # -- click
    session$setInputs('admin-confirm_import_data' = 1)
    session$setInputs('admin-confirm_data_model' = 1)


    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(1, length(DATA_MODEL_COLCLASSES)))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------


    x <- k_items()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(0, 1))


  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
