

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: filter data model cols
# --------------------------------------------------------------------------

test_that("Server works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE,
                 admin = TRUE)

  # -- module server call
  testServer(kitems, args = params, {

    # --------------------------------------------------------------------------
    # filter cols
    # --------------------------------------------------------------------------
    # -- flush reactive values
    session$flushReact()

    # -- update input
    session$setInputs('admin-dm_filter' = c("id", "total"))



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

clean_all()
