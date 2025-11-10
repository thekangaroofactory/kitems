

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: date sliderInput
# --------------------------------------------------------------------------

test_that("Date sliderInput works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 autosave = TRUE)

  # -- module server call
  testServer(kitems, args = params, {

    # --------------------------------------------------------------------------
    # date
    # --------------------------------------------------------------------------

    # -- update input
    session$setInputs(date_slider_strategy = "this-year")
    session$setInputs(date_slider = date_slider_value)

    # -- check
    expect_equal(dim(filtered_items()), c(2, 6))

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
