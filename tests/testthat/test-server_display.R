

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: display data model cols
# --------------------------------------------------------------------------

test_that("Server works", {

  # -- declare arguments
  params <- list(id = module_id, options = list(admin = TRUE))

  # -- module server call
  testServer(kitems, args = params, {

    # --------------------------------------------------------------------------
    # display cols
    # --------------------------------------------------------------------------
    # -- flush reactive values
    session$flushReact()

    # -- update input
    session$setInputs('admin-dm_display' = "id")


    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    x <- k_data_model()

    # -- tests
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), dim(dm))
    expect_equal(x$name[x$display], x$name)

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
