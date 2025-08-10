

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: delete item
# --------------------------------------------------------------------------

test_that("Delete works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 autosave = TRUE)

  # -- module server call
  testServer(kitems, args = params, {

    # --------------------------------------------------------------------------
    # delete
    # --------------------------------------------------------------------------

    x <- k_items()
    reference <- dim(x)

    # -- update input (click)
    session$setInputs(item_delete = 1)

    # -- select item
    session$setInputs(filtered_view_rows_selected = 1)

    # -- update input (click)
    session$setInputs(item_delete_confirm = 1)

    # -- check
    x <- k_items()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), reference - c(1, 0))

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
