

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: delete item
# --------------------------------------------------------------------------

test_that("Delete works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: delete item")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
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

    # -- simulate selection
    selected_items(k_items()$id[[1]])

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

clean_all(testdata_path)
