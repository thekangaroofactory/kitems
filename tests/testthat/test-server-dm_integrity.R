

# -- setup
create_integrity_testdata()


# --------------------------------------------------------------------------
# Scenario: data model integrity
# --------------------------------------------------------------------------

test_that("Data model integrity works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: data model integrity")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitems_server, args = params, {

    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    x <- k_data_model()

    # -- test class & dim
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), c(6, length(DATA_MODEL_COLCLASSES)))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    x <- k_items()

    # -- test class & dim
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), c(4, 6))

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
