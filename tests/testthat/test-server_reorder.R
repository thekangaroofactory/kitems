

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: reorder data model cols
# --------------------------------------------------------------------------

test_that("Server works", {

  # -- declare arguments
  params <- list(id = module_id, options = list(admin = TRUE))

  # -- module server call
  testServer(kitems, args = params, {

    # -- update input
    session$setInputs('admin-dm_sort' = names(dm_colClasses(dm)[order(names(dm_colClasses(dm)))]))


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
    expect_equal(x$name, names(dm_colClasses(dm)[order(names(dm_colClasses(dm)))]))


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
    expect_equal(colnames(x), names(dm_colClasses(dm)[order(names(dm_colClasses(dm)))]))


  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
