

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: min/max date when items has no row
# --------------------------------------------------------------------------

test_that("Min/max date works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: min/max date when items has no row")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitems_server, args = params, {

    # -- flush reactive values
    session$flushReact()

    # -- delete all items
    item_delete(k_items, k_items()$id)

    # -- flush reactive values
    session$flushReact()

    # -- check
    x <- k_items()

    # -- test class & dim
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x)[1], 0)


  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
