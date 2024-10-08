

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: create item
# --------------------------------------------------------------------------

test_that("Create works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: create item")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- click
    session$setInputs(create_btn = 1)

    # -- update inputs (values to create item)
    session$setInputs(id = NA)
    session$setInputs(date = NA)
    session$setInputs(name = "Orange")
    session$setInputs(quantity = 4)
    session$setInputs(total = 78.9)
    session$setInputs(isvalid = FALSE)

    # -- click
    session$setInputs(confirm_create_btn = 1)


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    x <- k_items()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(items) + c(1, 0))

    # -- delete create item
    item_delete(k_items, max(x$id))

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
