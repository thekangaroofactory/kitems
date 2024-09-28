

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Test
# --------------------------------------------------------------------------

test_that("Add attribute / dm_default_choice = fun works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: Add/delete attribute works")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- update input
    session$setInputs(dm_att_name = "my_date")
    session$setInputs(dm_att_type = "Date")
    session$setInputs(dm_default_choice = "fun")
    session$setInputs(dm_att_default_detail = "Sys.Date")

    # -- click
    session$setInputs(add_att = 1)

    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    # -- check
    r_data_model <- dm_name(module_id)
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_true(is.na(x[x$name == "my_date", ]$default.val))
    expect_equal(x[x$name == "my_date", ]$default.fun, "Sys.Date")

    # -- cleanup
    session$setInputs(dm_dz_att_name = "my_date")
    session$setInputs(dm_dz_delete_att = 1)
    session$setInputs(dm_dz_confirm_delete_att = 1)

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
