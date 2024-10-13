

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: date sliderInput
# --------------------------------------------------------------------------

test_that("Date sliderInput works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: date sliderInput")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # --------------------------------------------------------------------------
    # date
    # --------------------------------------------------------------------------

    # -- update input
    session$setInputs(date_slider_strategy = "this-year")
    session$setInputs(date_slider = date_slider_value)

    # -- check
    expect_equal(filter_date(), date_slider_value)

    # -- check filter
    expect_equal(dim(filtered_items()), c(2, 6))

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
