

# ------------------------------------------------------------------------------
# Declare shared objects
# ------------------------------------------------------------------------------

# -- declare namespace
ns <- shiny::NS("id")

# -- module id
module_id <- "data"


# --------------------------------------------------------------------------
# Setup test environment
# --------------------------------------------------------------------------

# -- create testdata folder
testdata_path <- file.path(system.file("tests", "testthat", package = "kitems"), "testdata")

# -- build urls
dm_url <- file.path(testdata_path, paste0(dm_name(module_id), ".rds"))
items_url <- file.path(testdata_path, paste0(items_name(module_id), ".csv"))
import_url <- "data_to_import.csv"


# ------------------------------------------------------------------------------
# Declare objects to build data model
# ------------------------------------------------------------------------------

# -- declare colClasses
colClasses <- c(id = "numeric", date = "POSIXct", name = "character", quantity = "integer", total = "numeric", isvalid = "logical")
colClasses_extra_att <- c(colClasses, extra_att = "integer")
colClasses_no_date <- colClasses[!names(colClasses) %in% "date"]
colClasses_id_only <- c(id = "numeric")

# -- declare default.val
default_val <- c("name" = "fruit", "isvalid" = TRUE)

# -- declare default.fun & arg
default_fun <- c("id" = "ktools::getTimestamp", "date" = "Sys.Date")
default_arg <- c("id" = "list(k = 10)")

# -- declare filter
filter <- c("id")

# -- declare filter
skip <- c("isvalid")


# ------------------------------------------------------------------------------
# Build data models
# ------------------------------------------------------------------------------

# -- build base data model
dm <- data_model(colClasses = colClasses, default.val = default_val, default.fun = default_fun, filter = filter, skip = skip)

# -- build specific data models
dm_nofilter <- data_model(colClasses = colClasses, default.val = default_val, default.fun = default_fun, filter = NULL, skip = skip)
dm_no_skip <- data_model(colClasses = colClasses, default.val = default_val, default.fun = default_fun, filter = filter, skip = NULL)
dm_extra_att <- data_model(colClasses = colClasses_extra_att, default.val = default_val, default.fun = default_fun, filter = filter, skip = skip)
dm_no_date <- data_model(colClasses = colClasses_no_date)
dm_id_only <- data_model(colClasses = colClasses_id_only, skip = "id")

# ------------------------------------------------------------------------------
# Build items
# ------------------------------------------------------------------------------

# -- build base items
item1 <- item_create(list(id = NA, date = NA, name = "Apple", quantity = 1, total = 12.5, isvalid = TRUE), dm)
item2 <- item_create(list(id = NA, date = "2024-01-14", name = "Banana", quantity = 12, total = 106.3, isvalid = FALSE), dm)
item3 <- item_create(list(id = NA, date = "2024-01-16", name = "Mango", quantity = 3, total = 45.7, isvalid = TRUE), dm)
item4 <- item_create(list(id = NA, date = "2024-01-17", name = "Orange", quantity = 7, total = 17.5, isvalid = FALSE), dm)
items <- rbind(item1, item2, item3, item4)

# -- items with additional attribute
items_extra_att <- items
items_extra_att$extra_att <- c("this", "is", "an", "extra")

# -- items without row
items_no_row <- data.frame("id" = as.numeric(numeric()),
                           "name" = as.character(character()))
items_no_row2 <- data.frame("id" = as.numeric(numeric()),
                            "date" = as.character(character()))

# -- items to test triggers
new_item <- item_create(list(id = NA, date = NA, name = "Raspberry", quantity = 34, total = 86.4, isvalid = TRUE), dm)
update_item <- item_create(list(id = items$id[1], date = NA, name = "Apple-update", quantity = 100, total = 0.1, isvalid = FALSE), dm)


# --------------------------------------------------------------------------
# Declare miscellaneous parameters
# --------------------------------------------------------------------------

# -- values to create item
values <- list("id" = c(170539948621),
               "date" = c(as.Date("2024-01-25", origin = "01-01-1970")),
               "name" = c("Orange"),
               "quantity" = 4,
               "total" = "78.9",
               "isvalid" = c(FALSE))


# -- simulate inputs from form
input_values <- list(name = "myname", quantity = 12, total = 34.8)


# -- item id (to delete)
item_id <- items$id[1]


# -- date selection
date_slider_value <- c(as.POSIXct(as.Date("2024-01-15")), as.POSIXct(as.Date("2024-01-17")))


# --------------------------------------------------------------------------
# Declare helper functions
# --------------------------------------------------------------------------

# -- helper: create test data
create_testdata <- function(){

  # -- create folder
  dir.create(testdata_path, showWarnings = FALSE)

  # -- save data model
  saveRDS(dm, file = dm_url)

  # -- save items
  item_save(items, file = items_url)

}


# -- helper: create empty items data
create_empty_items <- function(){

  # -- create folder
  dir.create(testdata_path, showWarnings = FALSE)

  # -- save data model
  saveRDS(data_model(colClasses = c(id = "numeric", date = "POSIXct")), file = dm_url)

  # -- save items
  item_save(items_no_row2, file = items_url)

}


# -- helper: create integrity test data
create_integrity_testdata <- function(){

  # -- create folder
  dir.create(testdata_path, showWarnings = FALSE)

  # -- alter data model
  dm <- dm[-3, ]

  # -- save data model
  saveRDS(dm, file = dm_url)

  # -- save items
  item_save(items, file = items_url)

}


# -- helper: create import data without id
create_noid_data_to_import <- function(){

  # -- create folder
  dir.create(testdata_path, showWarnings = FALSE)

  # -- save data model
  #saveRDS(dm, file = dm_url)

  # -- drop id column & save items
  items$id <- NULL
  item_save(items, file = items_url)

}


# -- helper: create data to import
create_data_to_import <- function(){

  # -- create folder
  dir.create(testdata_path, showWarnings = FALSE)

  # -- save items
  item_save(items, file = items_url)

}


# -- helper: cleanup function
clean_all <- function(testdata_path){

  unlink(testdata_path, recursive = TRUE)

}

