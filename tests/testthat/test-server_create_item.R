

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
  testServer(kitems_server, args = params, {

    # -- click
    session$setInputs(item_create = 1)

    # -- update inputs (values to create item)
    session$setInputs(id = NA)
    session$setInputs(date = Sys.Date())
    session$setInputs(date_time = "14:50:42")
    session$setInputs(date_tz = "CET")
    session$setInputs(name = "Orange")
    session$setInputs(quantity = 4)
    session$setInputs(total = 78.9)
    session$setInputs(isvalid = FALSE)

    # -- click
    session$setInputs(item_create_confirm = 1)


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    x <- k_items()

    # -- test class & dim
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), dim(items) + c(1, 0))

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
