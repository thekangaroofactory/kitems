

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: reorder & filter data model cols
# --------------------------------------------------------------------------

test_that("Server works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: reorder & filter data model cols")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- update input
    session$setInputs(dm_order_cols = names(colClasses[order(names(colClasses))]))


    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    r_data_model <- dm_name(module_id)
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(dm))

    # -- test names
    expect_equal(x$name, names(colClasses[order(names(colClasses))]))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    r_items <- items_name(module_id)
    x <- k_items()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(items))

    # -- test names
    expect_equal(colnames(x), names(colClasses[order(names(colClasses))]))


    # --------------------------------------------------------------------------
    # filter cols
    # --------------------------------------------------------------------------

    # -- update input
    session$setInputs(adm_filter_col = c("id", "total"))


    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    r_data_model <- dm_name(module_id)
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(dm))

    # -- test names
    expect_equal(x$name[x$filter], c("id", "total"))


  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
