

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

# -- disable traces
options("k.debug" = NULL)

# -- data folder
# adding module_id
testdata_base_path <- file.path(system.file("tests", "testthat", package = "kitems"), "testdata")
testdata_path <- file.path(testdata_base_path, module_id)

# -- build urls
dm_url <- file.path(testdata_path, paste0(dm_name(module_id), ".rds"))
items_url <- file.path(testdata_path, paste0(items_name(module_id), ".csv"))
items_file <- paste0(items_name(module_id), ".csv")
import_url <- file.path(testdata_path, "data_to_import.csv")


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
default_fun <- c("id" = "ktools::getTimestamp", "date" = "Sys.time")
default_arg <- c("id" = "list(k = 1000000)")

# -- declare display
display <- c("id")

# -- declare skip
skip <- c("isvalid")

# -- declare sort
sort_rank <- c("date" = 1)
sort_desc <- c("date" = TRUE)


# ------------------------------------------------------------------------------
# Build data models
# ------------------------------------------------------------------------------

# -- build base data model
dm <- data_model(colClasses = colClasses,
                 default.val = default_val, default.fun = default_fun, default.arg = default_arg,
                 display = display, skip = skip, sort.rank = sort_rank, sort.desc = sort_desc)

# -- build specific data models
dm_nodisplay <- data_model(colClasses = colClasses, default.val = default_val, default.fun = default_fun, display = NULL, skip = skip)
dm_no_skip <- data_model(colClasses = colClasses, default.val = default_val, default.fun = default_fun, display = display, skip = NULL)
dm_extra_att <- data_model(colClasses = colClasses_extra_att, default.val = default_val, default.fun = default_fun, display = display, skip = skip)
dm_no_date <- data_model(colClasses = colClasses_no_date)
dm_id_only <- data_model(colClasses = colClasses_id_only, skip = "id")
dm_sort <- data_model(colClasses = colClasses, sort.rank = c("date" = 1), sort.desc = c("date" = TRUE))

# ------------------------------------------------------------------------------
# Build items
# ------------------------------------------------------------------------------

# -- build base items
item1 <- rows_insert(NULL, list(id = NA, date = NA, name = "Apple", quantity = 1, total = 12.5, isvalid = TRUE), dm)
item2 <- rows_insert(NULL, list(id = NA, date = "2024-01-14", name = "Banana", quantity = 12, total = 106.3, isvalid = FALSE), dm)
item3 <- rows_insert(NULL, list(id = NA, date = "2024-01-16", name = "Mango", quantity = 3, total = 45.7, isvalid = TRUE), dm)
item4 <- rows_insert(NULL, list(id = NA, date = "2024-01-17", name = "Orange", quantity = 7, total = 17.5, isvalid = FALSE), dm)
items <- dplyr::bind_rows(item1, item2, item3, item4)

# -- items with additional attribute
items_extra_att <- items
items_extra_att$extra_att <- c("this", "is", "an", "extra")

# -- items without row
items_no_row <- data.frame("id" = as.numeric(numeric()),
                           "name" = as.character(character()))
items_no_row2 <- data.frame("id" = as.numeric(numeric()),
                            "date" = as.character(character()))

# -- items to test triggers
new_item <- rows_insert(NULL, list(id = NA, date = NA, name = "Raspberry", quantity = 34, total = 86.4, isvalid = TRUE), dm)
update_item <- rows_insert(NULL, list(id = items$id[1], date = NA, name = "Apple-update", quantity = 100, total = 0.1, isvalid = FALSE), dm)
update_item_2 <- rows_insert(NULL, list(id = items$id[2], date = NA, name = "Banana-update", quantity = 10, total = 0.1, isvalid = TRUE), dm)


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

# -- values to create multiple items (same lengths)
values_multiple <-  list("id" = c(170539948621, 170539948622),
                         "date" = c(Sys.Date(), Sys.Date()),
                         "name" = c("name_1", "name_2"),
                         "quantity" = c(4, 5),
                         "total" = c(78.9, 80.6),
                         "isvalid" = c(FALSE, TRUE))

# -- values to create multiple items (different lengths)
values_multiple_lengths <-  list("id" = c(170539948621, 170539948622),
                                 "date" = Sys.Date(),
                                 "name" = c("name_1", NA),
                                 "quantity" = c(4, 5),
                                 "total" = c(78.9, 12),
                                 "isvalid" = FALSE)

# -- values with extra column
values_extra_col <- list("id" = item1$id,
                         "name" = c("update"),
                         "quantity" = 400,
                         "dummy" = NA)


# -- simulate inputs from form
item_input_values <- list(name = "myname", quantity = 12, total = 34.8)


# -- item id (to delete)
item_id <- items$id[1]


# -- date selection
date_slider_value <- c(as.POSIXct(as.Date("2024-01-15")), as.POSIXct(as.Date("2024-01-17")))


# --------------------------------------------------------------------------
# Declare miscellaneous parameters
# --------------------------------------------------------------------------

# -- enable traces
# options("k.debug" = 1)


# --------------------------------------------------------------------------
# Declare helper functions
# --------------------------------------------------------------------------

# -- helper: create folder
create_folder <- function(){

  # -- create folder
  dir.create(testdata_path, recursive = TRUE, showWarnings = TRUE)

}


# -- helper: create test data
create_testdata <- function(){

  # -- create folder
  create_folder()

  # -- save data model
  saveRDS(dm, file = dm_url)

  # -- save items
  item_save(items, file = items_url)

}


# -- helper: create empty items data
create_empty_items <- function(){

  # -- create folder
  create_folder()

  # -- save data model
  saveRDS(data_model(colClasses = c(id = "numeric", date = "POSIXct")), file = dm_url)

  # -- save items
  item_save(items_no_row2, file = items_url)

}


# -- helper: create integrity test data
create_integrity_testdata <- function(){

  # -- create folder
  create_folder()

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
  create_folder()

  # -- drop id column & save items
  items$id <- NULL
  item_save(items, file = import_url)

}


# -- helper: create data to import
create_data_to_import <- function(){

  # -- create folder
  create_folder()

  # -- save items
  item_save(items, file = import_url)

}


# -- helper: cleanup function
clean_all <- function(){

  unlink(testdata_base_path, recursive = TRUE)
  options("k.debug" = NULL)

}

