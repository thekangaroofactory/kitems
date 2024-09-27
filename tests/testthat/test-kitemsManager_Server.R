

# --------------------------------------------------------------------------
# Scenario: without data model
# --------------------------------------------------------------------------

test_that("No data model works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: without data model")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # --------------------------------------------------------------------------
    # both data model & items should be NULL
    # --------------------------------------------------------------------------

    # -- data model
    x <- k_data_model()

    # -- test
    expect_null(x)

    # -- items
    x <- k_items()

    # -- test
    expect_null(x)


    # --------------------------------------------------------------------------
    # Create data model
    # --------------------------------------------------------------------------

    # -- click
    session$setInputs(dm_create = 1)

    # -- data model
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(1, 6))

    # -- items
    x <- k_items()

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
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    r_data_model <- dm_name(module_id)
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(6,6))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    r_items <- items_name(module_id)
    x <- k_items()

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
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    r_data_model <- dm_name(module_id)
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(6,6))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    r_items <- items_name(module_id)
    x <- k_items()

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
# Scenario: select data model attribute
# --------------------------------------------------------------------------


test_that("Select data model attribute works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: select data model attribute")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- click
    session$setInputs(data_model_rows_selected = 1)

    # --------------------------------------------------------------------------
    # Data model (dummy check)
    # --------------------------------------------------------------------------

    # -- check
    r_data_model <- dm_name(module_id)
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

  })

})


# --------------------------------------------------------------------------
# Scenario: add/delete attribute
# --------------------------------------------------------------------------

test_that("Add attribute works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: Add/delete attribute works")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- update input
    session$setInputs(dm_att_name = "status")
    session$setInputs(dm_att_type = "character")
    session$setInputs(dm_default_choice = "val")
    session$setInputs(dm_att_default_detail = "draft")
    session$setInputs(dm_att_skip = FALSE)

    # -- click
    session$setInputs(add_att = 1)


    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    # -- check
    r_data_model <- dm_name(module_id)
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(dm) + c(1, 0))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    r_items <- items_name(module_id)
    x <- k_items()

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
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(dm))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    r_items <- items_name(module_id)
    x <- k_items()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(items))


  })

})


test_that("Add attribute / dm_default_choice = none works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: Add/delete attribute works")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- update input
    session$setInputs(dm_att_name = "my_att")
    session$setInputs(dm_att_type = "character")
    session$setInputs(dm_default_choice = "none")

    # -- click
    session$setInputs(add_att = 1)

    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    # -- check
    r_data_model <- dm_name(module_id)
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_true(is.na(x[x$name == "my_att", ]$default.val))
    expect_true(is.na(x[x$name == "my_att", ]$default.fun))

    # -- cleanup
    session$setInputs(dm_dz_att_name = "my_att")
    session$setInputs(dm_dz_delete_att = 1)
    session$setInputs(dm_dz_confirm_delete_att = 1)

  })

})


test_that("Add attribute / dm_default_choice = fun works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: Add/delete attribute works")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- update input
    session$setInputs(dm_att_name = "my_date")
    session$setInputs(dm_att_type = "Date")
    session$setInputs(dm_default_choice = "fun")
    session$setInputs(dm_att_default_detail = "Sys.Date")

    # -- click
    session$setInputs(add_att = 1)

    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    # -- check
    r_data_model <- dm_name(module_id)
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_true(is.na(x[x$name == "my_date", ]$default.val))
    expect_equal(x[x$name == "my_date", ]$default.fun, "Sys.Date")

    # -- cleanup
    session$setInputs(dm_dz_att_name = "my_date")
    session$setInputs(dm_dz_delete_att = 1)
    session$setInputs(dm_dz_confirm_delete_att = 1)

  })

})


# --------------------------------------------------------------------------
# Scenario: update data model
# --------------------------------------------------------------------------

test_that("Update attribute / dm_default_choice = none works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: Update attribute / dm_default_choice = none works")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- update input
    session$setInputs(data_model_rows_selected = 1)
    session$setInputs(dm_default_choice = "none")

    # -- click
    session$setInputs(upd_att = 1)

    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    # -- check
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test values
    expect_true(is.na(x[1, ]$default.val))
    expect_false(is.na(x[1, ]$default.fun))

  })

})


test_that("Update attribute / dm_default_choice = val works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: Update attribute / dm_default_choice = val works")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- update input
    session$setInputs(data_model_rows_selected = 3)
    session$setInputs(dm_att_type = "character")
    session$setInputs(dm_default_choice = "val")
    session$setInputs(dm_att_default_detail = "update_fruit")

    # -- click
    session$setInputs(upd_att = 1)

    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    # -- check
    r_data_model <- dm_name(module_id)
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test values
    expect_equal(x[3, ]$default.val, "update_fruit")
    expect_true(is.na(x[3, ]$default.fun))

  })

})


test_that("Update attribute / dm_default_choice = fun works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: Update attribute / dm_default_choice = fun works")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- update input
    session$setInputs(data_model_rows_selected = 3)
    session$setInputs(dm_att_type = "character")
    session$setInputs(dm_default_choice = "fun")
    session$setInputs(dm_att_default_detail = "Sys.timezone")

    # -- click
    session$setInputs(upd_att = 1)

    # --------------------------------------------------------------------------
    # Data model
    # --------------------------------------------------------------------------

    # -- check
    r_data_model <- dm_name(module_id)
    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test values
    expect_equal(x[3, ]$default.fun, "Sys.timezone")
    expect_true(is.na(x[3, ]$default.val))

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
    x <- k_data_model()

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
    x <- k_items()

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
    x <- k_data_model()

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
    session$setInputs(date_slider = date_slider_value)

    # -- check
    expect_equal(filter_date(), date_slider_value)

    # -- check filter
    expect_equal(dim(filtered_items()), c(2, 6))

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
    expect_equal(selected_items(), k_items()$id[1:2])

    # -- flush reactive values
    session$flushReact()

    # -- update input
    session$setInputs(filtered_view_rows_selected = c(3,4))

    # -- check
    expect_equal(selected_items(), k_items()$id[1:2])


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

    x <- k_items()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), dim(items) + c(1, 0))

    # -- delete create item
    item_delete(k_items, max(x$id))

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

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), reference)

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
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # --------------------------------------------------------------------------
    # delete
    # --------------------------------------------------------------------------

    x <- k_items()
    reference <- dim(x)

    # -- update input (click)
    session$setInputs(delete_btn = 1)

    # -- simulate selection
    selected_items(k_items()$id[[1]])

    # -- update input (click)
    session$setInputs(confirm_delete_btn = 1)

    # -- check
    x <- k_items()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(4, 6))

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
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- flush reactive values
    session$flushReact()

    # -- delete all items
    item_delete(k_items, k_items()$id)

    # -- flush reactive values
    session$flushReact()

    # -- check
    x <- k_items()

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

test_that("Import data works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: import data")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
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

    x <- k_data_model()
    str(x)

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(1,6))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------


    r_items <- items_name(module_id)
    x <- k_items()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(0, 1))


  })

})


# --------------------------------------------------------------------------
# Scenario: import data without id
# --------------------------------------------------------------------------

# -- Cleanup & create test data
clean_all(testdata_path)
create_noid_data_to_import()


test_that("Import data without id works", {

  cat("\n-------------------------------------------------------------------------- \n")
  cat("Scenario: Import data without id works")
  cat("\n-------------------------------------------------------------------------- \n")

  # -- declare arguments
  params <- list(id = module_id,
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

    x <- k_data_model()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(1, 6))


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------


    x <- k_items()

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
