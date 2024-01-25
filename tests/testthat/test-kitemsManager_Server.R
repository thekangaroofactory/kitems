

test_that("kitemsManager_Server works", {

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 file = test_file,
                 path = path,
                 data.model = dm_test_file,
                 create = FALSE,
                 autosave = FALSE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- test output: date_slider
    expect_snapshot(output$date_slider)

    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    r_data_model <- dm_name(module_id)
    x <- r[[r_data_model]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(5,6))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    r_items <- items_name(module_id)
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(4,5))

  })


})
