

# -- Create test data
create_noid_data_to_import()

# --------------------------------------------------------------------------
# Scenario: import data without id
# --------------------------------------------------------------------------

test_that("Import data without id works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 autosave = TRUE,
                 admin = TRUE)

  # -- module server call
  testServer(kitems, args = params, {

    # -- click
    session$setInputs('admin-import' = 1)

    # -- create input value
    value <- data.frame(name = "data_to_import",
                        size = 12,
                        type = "dummy",
                        datapath = import_url)

    # -- set file input & click
    session$setInputs('admin-import-file' = value)
    session$setInputs('admin-import-file_confirm' = 1)

    # -- click
    session$setInputs('admin-import-items_confirm' = 1)
    session$setInputs('admin-import-dm_confirm' = 1)


    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(6, length(DATA_MODEL_COLCLASSES)))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------


    x <- k_items()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(4, 6))


  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
