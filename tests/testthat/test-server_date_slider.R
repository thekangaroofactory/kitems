

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: date sliderInput
# --------------------------------------------------------------------------

test_that("Date sliderInput works", {

  # -- declare arguments
  params <- list(id = module_id)

  # -- module server call
  testServer(kitems, args = params, {

    # --------------------------------------------------------------------------
    # date
    # --------------------------------------------------------------------------

    # -- get value from the items
    date_slider_value <- max(items$date, na.rm = T)
    nb <- nrow(items[items$date == date_slider_value, ])

    # -- update input
    session$setInputs(date_slider_strategy = "this-year")
    session$setInputs(date_slider = c(date_slider_value, date_slider_value))

    # -- check
    expect_equal(nrow(filtered_items()), nb)

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
