

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: add attribute
# --------------------------------------------------------------------------

test_that("Add attribute works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: Add attribute works")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- update input
    session$setInputs(dm_att_name = "status")
    session$setInputs(dm_att_type = "character")
    session$setInputs(dm_default_choice = "val")
    session$setInputs(dm_att_default_detail = "draft")
    session$setInputs(dm_att_skip = FALSE)

    # -- click
    session$setInputs(add_att = 1)


    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    # -- check
    x <- k_data_model()

    # -- test class & dim
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), dim(dm) + c(1, 0))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    x <- k_items()

    # -- test class & dim
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), dim(items) + c(0, 1))

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
