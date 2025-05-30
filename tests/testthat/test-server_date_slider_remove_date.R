

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: date sliderInput remove date attribute
# --------------------------------------------------------------------------

test_that("Date sliderInput remove date attribute works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 autosave = TRUE,
                 admin = TRUE)

  # -- module server call
  testServer(kitems, args = params, {

    # --------------------------------------------------------------------------
    # date
    # --------------------------------------------------------------------------

    # -- update input
    session$setInputs(date_slider_strategy = "this-year")
    session$setInputs(date_slider = date_slider_value)

    # -- update input & click
    session$setInputs('admin-dz_delete_att_name' = "date")
    session$setInputs('admin-dz_delete_att' = 1)
    session$setInputs('admin-dz_delete_att_confirm' = 1)

    # -- check
    expect_null(filter_date())

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
