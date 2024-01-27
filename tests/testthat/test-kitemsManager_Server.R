

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
    expect_equal(dim(x), c(4, 5))


    # --------------------------------------------------------------------------
    # Trigger new
    # --------------------------------------------------------------------------

    # -- trigger call
    r_trigger_add <- trigger_add_name(module_id)
    r[[r_trigger_add]](item_new_2)

    # -- flush reactive values
    session$flushReact()

    # -- check
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(5, 5))

    # -- test id
    expect_true(item_new_2$id %in% x$id)


    # --------------------------------------------------------------------------
    # Trigger update
    # --------------------------------------------------------------------------

    r_trigger_update <- trigger_update_name(module_id)
    r[[r_trigger_update]](item_update_2)

    # -- flush reactive values
    session$flushReact()

    # -- check
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(5, 5))

    # -- test id
    expect_equal(x[x$id == item_update_2$id, ]$comment, item_update_2$comment)


    # --------------------------------------------------------------------------
    # Trigger delete
    # --------------------------------------------------------------------------

    r_trigger_delete <- trigger_delete_name(module_id)
    r[[r_trigger_delete]](item_update_2)

    # -- flush reactive values
    session$flushReact()

    # -- check
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(4, 5))

    # -- test id
    expect_false(item_update_2$id %in% x$id)


    # --------------------------------------------------------------------------
    # date
    # --------------------------------------------------------------------------

    # -- update input
    session$setInputs(date_slider = date_slider_value)

    # -- check
    expect_equal(r[[r_filter_date]](), date_slider_value)

    # -- check filter
    expect_equal(dim(r[[r_filtered_items]]()), c(2, 5))


  })


})
