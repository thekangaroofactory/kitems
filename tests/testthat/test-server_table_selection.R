

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: in table selection
# --------------------------------------------------------------------------

test_that("Selection works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: in table selection")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # --------------------------------------------------------------------------
    # select rows
    # --------------------------------------------------------------------------

    # -- flush reactive values
    session$flushReact()

    # -- update input
    session$setInputs(filtered_view_rows_selected = c(3,4))

    # -- check
    expect_equal(selected_items(), k_items()$id[1:2])


  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
