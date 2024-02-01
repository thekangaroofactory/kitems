

# --------------------------------------------------------------------------
# Scenario: without data model
# --------------------------------------------------------------------------

test_that("No data model works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: without data model")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 path = testdata_path,
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


# --------------------------------------------------------------------------
# Scenario: test with data model & item file
# --------------------------------------------------------------------------

# -- create data
create_testdata()

test_that("Server works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: test with data model & item file")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 path = testdata_path,
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
# Scenario: data model integrity
# --------------------------------------------------------------------------

# -- setup
clean_all(testdata_path)
create_integrity_testdata()


test_that("Data model integrity works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: data model integrity")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 path = testdata_path,
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
# Cleanup
# --------------------------------------------------------------------------

# -- setup
clean_all(testdata_path)
create_testdata()


# --------------------------------------------------------------------------
# Scenario: add/delete attribute
# --------------------------------------------------------------------------

test_that("Add attribute works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: Add/delete attribute works")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- update input
    session$setInputs(add_att_name = "status")
    session$setInputs(add_att_type = "character")
    session$setInputs(add_att_default_val = "draft")
    session$setInputs(add_att_default_fun = NA)
    session$setInputs(add_att_skip = FALSE)

    # -- click
    session$setInputs(add_att = 1)


    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    # -- check
    r_data_model <- dm_name(module_id)
    x <- r[[r_data_model]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(dm) + c(1, 0))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    r_items <- items_name(module_id)
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(items) + c(0, 1))


    # --------------------------------------------------------------------------
    # Delete attribute
    # --------------------------------------------------------------------------

    # -- update input & click
    session$setInputs(dm_dz_att_name = "status")
    session$setInputs(dm_dz_delete_att = 1)
    session$setInputs(dm_dz_confirm_delete_att = 1)


    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    # -- check
    r_data_model <- dm_name(module_id)
    x <- r[[r_data_model]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(dm))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    r_items <- items_name(module_id)
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(items))


  })

})


# --------------------------------------------------------------------------
# Scenario: reorder & filter data model cols
# --------------------------------------------------------------------------

test_that("Server works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: reorder & filter data model cols")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- update input
    session$setInputs(dm_order_cols = names(colClasses[order(names(colClasses))]))


    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    r_data_model <- dm_name(module_id)
    x <- r[[r_data_model]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(dm))

    # -- test names
    expect_equal(x$name, names(colClasses[order(names(colClasses))]))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    r_items <- items_name(module_id)
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(items))

    # -- test names
    expect_equal(colnames(x), names(colClasses[order(names(colClasses))]))


    # --------------------------------------------------------------------------
    # filter cols
    # --------------------------------------------------------------------------

    # -- update input
    session$setInputs(adm_filter_col = c("id", "total"))


    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    r_data_model <- dm_name(module_id)
    x <- r[[r_data_model]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(dm))

    # -- test names
    expect_equal(x$name[x$filter], c("id", "total"))


  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
create_testdata()


# --------------------------------------------------------------------------
# Scenario: test triggers
# --------------------------------------------------------------------------

test_that("TRIGGERS work", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: test triggers")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- flush reactive values
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
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
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
                 r = r,
                 path = testdata_path,
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
    expect_equal(dim(r[[r_filtered_items]]()), c(2, 6))

  })

})


# --------------------------------------------------------------------------
# Scenario: in table selection
# --------------------------------------------------------------------------

test_that("Selection works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: in table selection")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 path = testdata_path,
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
    expect_equal(r[[r_selected_items]](), r[[r_items]]()$id[1:2])


  })

})


# --------------------------------------------------------------------------
# Scenario: create item
# --------------------------------------------------------------------------

test_that("Create works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: create item")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
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

    r_items <- items_name(module_id)
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(items) + c(1, 0))

  })

})


# --------------------------------------------------------------------------
# Scenario: update item
# --------------------------------------------------------------------------

test_that("Update works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: update item")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- get items
    r_items <- items_name(module_id)
    x <- r[[r_items]]()

    # -- flush reactive values
    session$flushReact()

    # -- select item
    r[[r_selected_items]](x$id[1])

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


    r_items <- items_name(module_id)
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(items))

    # -- test name
    expect_true(grepl("updated", x$name[1], fixed = TRUE))

  })

})


# --------------------------------------------------------------------------
# Scenario: delete item
# --------------------------------------------------------------------------

test_that("Delete works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: delete item")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 path = testdata_path,
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
    expect_equal(dim(x), dim(items) - c(1, 0))

  })

})


# --------------------------------------------------------------------------
# Scenario: min/max date when items has no row
# --------------------------------------------------------------------------

test_that("Min/max date works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: min/max date when items has no row")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- flush reactive values
    session$flushReact()

    # -- delete all items
    r_trigger_delete <- trigger_delete_name(module_id)
    r[[r_trigger_delete]](r[[r_items]]()$id)

    # -- flush reactive values
    session$flushReact()

    # -- check
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x)[1], 0)


  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)


# --------------------------------------------------------------------------
# Scenario: import data
# --------------------------------------------------------------------------

# -- create test data
create_data_to_import()

test_that("Import works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: import data")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 r = r,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- click
    session$setInputs(import_data = 1)

    # -- create input value
    value <- data.frame(name = "data_to_import",
                        size = 12,
                        type = "dummy",
                        datapath = file.path(testdata_path, import_url))

    # -- set file input & click
    session$setInputs(input_file = value)
    session$setInputs(confirm_import_file = 1)

    # -- click
    session$setInputs(confirm_import_data = 1)
    session$setInputs(confirm_data_model = 1)


    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    r_data_model <- dm_name(module_id)
    x <- r[[r_data_model]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(dm))


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
# Cleanup
# --------------------------------------------------------------------------

clean_all(testdata_path)
