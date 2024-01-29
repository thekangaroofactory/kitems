


# --------------------------------------------------------------------------
# Setup test environment & data
# --------------------------------------------------------------------------

# -- create testdata folder
testdata_path <- file.path(system.file("tests", "testthat", package = "kitems"), "testdata")
dir.create(testdata_path)


test_path = list(data = testdata_path,
                 resource = testdata_path)


# -- module id
module_id <- "data"

# -- declare communication object
r <- reactiveValues()


# -- data model

# -- declare colClasses
colClasses <- c(id = "double",
                date = "POSIXct",
                name = "character",
                quantity = "integer",
                total = "numeric",
                isvalid = "logical")

# -- declare default.val
default_val <- c("name" = "fruit", "isvalid" = TRUE)

# -- declare default.fun
default_fun <- c("id" = "ktools::getTimestamp", "date" = "Sys.Date")

# -- declare filter
filter <- c("id")

# -- declare filter
skip <- c("isvalid")

# -- build data model
dm <- data_model(colClasses = colClasses, default.val = default_val, default.fun = default_fun, filter = filter, skip = skip)

# -- save data model
dm_url <- file.path(testdata_path, paste0(dm_name(module_id), ".rds"))
saveRDS(dm, file = dm_url)


# -- items

items <- item_create(list(id = NA, date = NA, name = "Apple", quantity = 1, total = 12.5, isvalid = TRUE), dm)
new_item <- item_create(list(id = NA, date = NA, name = "Banana", quantity = 12, total = 106.3, isvalid = FALSE), dm)
items <- item_add(items, new_item)
new_item <- item_create(list(id = NA, date = NA, name = "Mango", quantity = 3, total = 45.7, isvalid = TRUE), dm)
items <- item_add(items, new_item)
new_item <- item_create(list(id = NA, date = NA, name = "Orange", quantity = 7, total = 17.5, isvalid = FALSE), dm)
items <- item_add(items, new_item)

item_save(items, file = "my_data.csv", path = testdata_path)

new_item <- item_create(list(id = NA, date = NA, name = "Raspberry", quantity = 34, total = 86.4, isvalid = TRUE), dm)
update_item <- item_create(list(id = NA, date = NA, name = "Apple update", quantity = 100, total = 0.1, isvalid = FALSE), dm)



test_that("kitemsManager_Server works", {

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

    # -- get the id of the item that was just added before
    id_delete <- r[[r_items]]()[ r[[r_items]]()$name == new_item$name, ]$id


    r_trigger_delete <- trigger_delete_name(module_id)
    r[[r_trigger_delete]](id_delete)

    # -- flush reactive values
    session$flushReact()

    # -- check
    x <- r[[r_items]]()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), c(4, 6))

    # -- test id
    expect_false(update_item$id %in% x$id)


    # --------------------------------------------------------------------------
    # date
    # --------------------------------------------------------------------------

    # -- update input
    # session$setInputs(date_slider = date_slider_value)
    #
    # # -- check
    # expect_equal(r[[r_filter_date]](), date_slider_value)
    #
    # # -- check filter
    # expect_equal(dim(r[[r_filtered_items]]()), c(2, 5))


    # --------------------------------------------------------------------------
    # delete
    # --------------------------------------------------------------------------

    # -- update input (click)
    # session$setInputs(delete_btn = 1)
    #
    # # -- simulate selection
    # r[[r_selected_items]](item_id)
    #
    # # -- update input (click)
    # session$setInputs(confirm_delete_btn = 1)


  })


})
