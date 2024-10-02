

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Test
# --------------------------------------------------------------------------

test_that("Update attribute / dm_default_choice = fun works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: Update attribute / dm_default_choice = fun works")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- update input
    session$setInputs(data_model_rows_selected = 3)
    session$setInputs(dm_att_type = "character")
    session$setInputs(dm_default_choice = "fun")
    session$setInputs(dm_att_default_detail = "Sys.timezone")
    session$setInputs(dm_att_skip = FALSE)

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
    expect_equal(x[3, ]$default.fun, "Sys.timezone")
    expect_true(is.na(x[3, ]$default.val))


  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
