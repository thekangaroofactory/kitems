

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: update data model
# --------------------------------------------------------------------------

test_that("Update attribute / dm_default_choice = none works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: Update attribute / dm_default_choice = none works")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- update input
    session$setInputs(data_model_rows_selected = 1)
    session$setInputs(dm_default_choice = "none")

    # -- click
    session$setInputs(upd_att = 1)

    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    # -- check
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test values
    expect_true(is.na(x[1, ]$default.val))
    expect_false(is.na(x[1, ]$default.fun))

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
