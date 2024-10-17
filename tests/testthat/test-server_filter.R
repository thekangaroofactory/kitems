

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: filter data model cols
# --------------------------------------------------------------------------

test_that("Server works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: filter data model cols")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitems_server, args = params, {

    # --------------------------------------------------------------------------
    # filter cols
    # --------------------------------------------------------------------------
    # -- flush reactive values
    session$flushReact()

    # -- update input
    session$setInputs('admin-adm_filter_col' = c("id", "total"))



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
