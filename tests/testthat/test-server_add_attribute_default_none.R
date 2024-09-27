

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Test
# --------------------------------------------------------------------------

test_that("Add attribute / dm_default_choice = none works", {

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
    session$setInputs(dm_att_name = "my_att")
    session$setInputs(dm_att_type = "character")
    session$setInputs(dm_default_choice = "none")

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
    expect_true(is.na(x[x$name == "my_att", ]$default.val))
    expect_true(is.na(x[x$name == "my_att", ]$default.fun))

    # -- cleanup
    session$setInputs(dm_dz_att_name = "my_att")
    session$setInputs(dm_dz_delete_att = 1)
    session$setInputs(dm_dz_confirm_delete_att = 1)

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
