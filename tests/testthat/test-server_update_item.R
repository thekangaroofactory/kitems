

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: update item
# --------------------------------------------------------------------------

test_that("Update works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: update item")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- get items
    x <- k_items()
    reference <- dim(x)

    # -- flush reactive values
    session$flushReact()

    # -- select item
    selected_items(x$id[1])

    # -- click
    session$setInputs(update_btn = 1)

    # -- update inputs (values to create item)
    session$setInputs(id = x$id[1])
    session$setInputs(date = x$date[1] + 1)
    session$setInputs(name = paste0(x$name[1], "-updated"))
    session$setInputs(quantity = x$quantity[1] + 10)
    session$setInputs(total = x$total[1] + 0.5)
    session$setInputs(isvalid = !x$isvalid[1])

    # -- click
    session$setInputs(confirm_update_btn = 1)


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    x <- k_items()

    # -- test class & dim
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), reference)

    # -- test name
    expect_true(grepl("updated", x$name[1], fixed = TRUE))

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
