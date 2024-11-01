

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: delete attribute
# --------------------------------------------------------------------------

test_that("delete attribute works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: delete attribute works")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitems, args = params, {

    # -- update input & click
    session$setInputs('admin-dz_delete_att_name' = "status")
    session$setInputs('admin-dz_delete_att' = 1)
    session$setInputs('admin-dz_delete_att_confirm' = 1)


    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    # -- check
    x <- k_data_model()

    # -- test class & dim
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), dim(dm))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    x <- k_items()

    # -- test class & dim
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), dim(items))


  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
