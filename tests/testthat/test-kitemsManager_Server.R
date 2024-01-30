

# -- create data
create_testdata()


# --------------------------------------------------------------------------
# Scenario: test with data model & item file
# --------------------------------------------------------------------------

test_that("Server works", {

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 file = "my_data.csv",
                 path = test_path,
                 data.model = dm,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    r_data_model <- dm_name(module_id)
    x <- r[[r_data_model]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(6,6))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    r_items <- items_name(module_id)
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(4, 6))

  })

})


# --------------------------------------------------------------------------
# Scenario: test with data model & item file
# --------------------------------------------------------------------------

test_that("TRIGGERS work", {

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 file = "my_data.csv",
                 path = test_path,
                 data.model = dm,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    session$flushReact()

    # --------------------------------------------------------------------------
    # Trigger new
    # --------------------------------------------------------------------------

    # -- trigger call
    r_trigger_add <- trigger_add_name(module_id)
    r[[r_trigger_add]](new_item)

    # -- flush reactive values
    session$flushReact()

    # -- check
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(5, 6))

    # -- test id
    expect_true(new_item$id %in% x$id)


    # --------------------------------------------------------------------------
    # Trigger update
    # --------------------------------------------------------------------------

    r_trigger_update <- trigger_update_name(module_id)
    r[[r_trigger_update]](update_item)

    # -- flush reactive values
    session$flushReact()

    # -- check
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(5, 6))

    # -- test id
    expect_equal(x[x$id == update_item$id, ]$comment, update_item$comment)


    # --------------------------------------------------------------------------
    # Trigger delete
    # --------------------------------------------------------------------------

    r_trigger_delete <- trigger_delete_name(module_id)
    r[[r_trigger_delete]](new_item$id)

    # -- flush reactive values
    session$flushReact()

    # -- check
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(4, 6))

    # -- test id
    expect_false(new_item$id %in% x$id)


    # --------------------------------------------------------------------------
    # Trigger save
    # --------------------------------------------------------------------------

    # -- get the id of the item that was just added before
    r_trigger_save <- trigger_save_name(module_id)
    r[[r_trigger_save]](1)

    # -- flush reactive values
    session$flushReact()


  })

})


# --------------------------------------------------------------------------
# Scenario: date sliderInput
# --------------------------------------------------------------------------

test_that("Date sliderInput works", {

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 file = "my_data.csv",
                 path = test_path,
                 data.model = dm,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # --------------------------------------------------------------------------
    # date
    # --------------------------------------------------------------------------

    # -- update input
    session$setInputs(date_slider = date_slider_value)

    # -- check
    expect_equal(r[[r_filter_date]](), date_slider_value)

    # -- check filter
    expect_equal(dim(r[[r_filtered_items]]()), c(0, 6))

  })

})


# --------------------------------------------------------------------------
# Scenario: in table selection
# --------------------------------------------------------------------------

test_that("Selection works", {

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 file = "my_data.csv",
                 path = test_path,
                 data.model = dm,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # --------------------------------------------------------------------------
    # select rows
    # --------------------------------------------------------------------------

    # -- flush reactive values
    session$flushReact()

    # -- update input
    session$setInputs(default_view_rows_selected = c(1,2))

    # -- check
    expect_equal(r[[r_selected_items]](), r[[r_items]]()$id[1:2])

    # -- flush reactive values
    session$flushReact()

    # -- update input
    session$setInputs(filtered_view_rows_selected = c(3,4))

    # -- check
    expect_equal(r[[r_selected_items]](), NULL)


  })

})


# --------------------------------------------------------------------------
# Scenario: delete item
# --------------------------------------------------------------------------

test_that("Delete works", {

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 file = "my_data.csv",
                 path = test_path,
                 data.model = dm,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # --------------------------------------------------------------------------
    # delete
    # --------------------------------------------------------------------------

    # -- update input (click)
    session$setInputs(delete_btn = 1)

    # -- simulate selection
    r[[r_selected_items]](r[[r_items]]()$id[[1]])

    # -- update input (click)
    session$setInputs(confirm_delete_btn = 1)

    # -- check
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(3, 6))

  })

})


# --------------------------------------------------------------------------
# Scenario: without data model
# --------------------------------------------------------------------------

# -- cleanup test data
clean_all(testdata_path)


test_that("No data model works", {

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 file = "my_data.csv",
                 path = test_path,
                 data.model = NULL,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # --------------------------------------------------------------------------
    # both data model & items should be NULL
    # --------------------------------------------------------------------------

    # -- data model
    x <- r[[r_data_model]]()

    # -- test
    expect_null(x)

    # -- items
    x <- r[[r_items]]()

    # -- test
    expect_null(x)


    # --------------------------------------------------------------------------
    # Create data model
    # --------------------------------------------------------------------------

    # -- click
    session$setInputs(dm_create = 1)

    # -- data model
    x <- r[[r_data_model]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(1, 6))

    # -- items
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(0, 1))

  })

})

# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
