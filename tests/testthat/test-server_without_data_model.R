
# --------------------------------------------------------------------------
# Scenario: launch server without data model
# --------------------------------------------------------------------------

test_that("launch server without data model", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: launch server without data model")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # --------------------------------------------------------------------------
    # both data model & items should be NULL
    # --------------------------------------------------------------------------

    # -- data model
    expect_null(k_data_model())

    # -- items
    expect_null(k_items())


    # --------------------------------------------------------------------------
    # Create data model
    # --------------------------------------------------------------------------

    # -- click
    session$setInputs(dm_create = 1)

    # -- data model
    x <- k_data_model()

    # -- test class & dim
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), c(1, 6))

    # -- items
    x <- k_items()

    # -- test class & dim
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), c(0, 1))

  })

})

# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
