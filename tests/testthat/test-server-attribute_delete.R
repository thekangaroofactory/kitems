
# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: attribute delete
# --------------------------------------------------------------------------

test_that("attribute delete works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: attribute delete")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE,
                 admin = TRUE)

  # -- module server call
  testServer(kitems_server, args = params, {

    # -- update input
    session$setInputs('admin-dz_delete_att_name' = "total")
    session$setInputs('admin-dz_delete_att' = 1)
    session$setInputs('admin-dz_delete_att_confirm' = 1)

    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), dim(dm) - c(1, 0))

    # -- test names
    expect_false("total" %in% x$name)


    # --------------------------------------------------------------------------
    # Delete all attributes
    # --------------------------------------------------------------------------

    # -- update input
    session$setInputs('admin-dz_delete_att_name' = "isvalid")
    session$setInputs('admin-dz_delete_att' = 1)
    session$setInputs('admin-dz_delete_att_confirm' = 1)
    session$setInputs('admin-dz_delete_att_name' = "quantity")
    session$setInputs('admin-dz_delete_att' = 1)
    session$setInputs('admin-dz_delete_att_confirm' = 1)
    session$setInputs('admin-dz_delete_att_name' = "name")
    session$setInputs('admin-dz_delete_att' = 1)
    session$setInputs('admin-dz_delete_att_confirm' = 1)
    session$setInputs('admin-dz_delete_att_name' = "date")
    session$setInputs('admin-dz_delete_att' = 1)
    session$setInputs('admin-dz_delete_att_confirm' = 1)
    session$setInputs('admin-dz_delete_att_name' = "id")
    session$setInputs('admin-dz_delete_att' = 1)
    session$setInputs('admin-dz_delete_att_confirm' = 1)

    # --------------------------------------------------------------------------
    # Data model & items
    # --------------------------------------------------------------------------

    # -- test reactives
    expect_null(k_data_model())
    expect_null(k_items())

    # -- test files
    expect_false(file.exists(dm_url))
    expect_false(file.exists(items_url))


  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
