

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

# -- set environment variable
Sys.setenv("R_KITEMS_PATH" = testdata_path)

# -- build urls
test_dm_url <- dm_url(module_id)
test_items_url <- items_url(module_id)
items_file <- paste0(items_name(module_id), ".csv")
import_url <- file.path(testdata_path, "data_to_import.csv")


# ------------------------------------------------------------------------------
# Declare objects to build data model
# ------------------------------------------------------------------------------

# -- declare colClasses
colClasses <- c(date = "POSIXct", name = "character", quantity = "integer", total = "numeric", isvalid = "logical")
colClasses_extra_att <- c(colClasses, extra_att = "integer")
colClasses_no_date <- colClasses[!names(colClasses) %in% "date"]
colClasses_id_only <- c(id = "numeric")

# -- declare default
default <- c(name = "fruit", isvalid = TRUE, date = "Sys.time()")

# -- declare skip
# skip <- c("isvalid")

# -- declare sort
sort_rank <- c("date" = 1L)
sort_desc <- c("date" = TRUE)


# ------------------------------------------------------------------------------
# Build data models
# ------------------------------------------------------------------------------

# -- build base data model
dm <- data_model(colClasses = colClasses,
                 default = default,
                 sort.rank = sort_rank, sort.desc = sort_desc)

# -- build specific data models
dm_nodisplay <- data_model(colClasses = colClasses, default = default, display = FALSE)
dm_no_skip <- data_model(colClasses = colClasses, default = default)
dm_extra_att <- data_model(colClasses = colClasses_extra_att, default = default)
dm_no_date <- data_model(colClasses = colClasses_no_date)
dm_id_only <- data_model(colClasses = colClasses_id_only, skip = TRUE)
dm_sort <- data_model(colClasses = colClasses, sort.rank = sort_rank, sort.desc = sort_desc)

# ------------------------------------------------------------------------------
# Build items
# ------------------------------------------------------------------------------

values <- list(date = c(NA, "2024-01-14", "2024-01-16", "2024-01-17"),
               name = c("Apple", "Banana", "Mango", "Orange"),
               quantity = c(1, 12, 3, 7),
               total = c(12.5, 106.3, 45.7, 17.5),
               isvalid = c(TRUE, FALSE, TRUE, FALSE))

# -- build base items
items <- values |>
  prepare_values(dm) |>
  attribute_values(dm) |>
  rows_insert(data.frame())

# -- items with additional attribute
items_extra_att <- items
items_extra_att$extra_att <- c("this", "is", "an", "extra")

# -- items without row
items_no_row <- data.frame("id" = as.numeric(numeric()),
                           "name" = as.character(character()))
items_no_row2 <- data.frame("id" = as.numeric(numeric()),
                            "date" = as.character(character()))

# -- items to test triggers
new_item <- list(name = "Raspberry", quantity = 34, total = 86.4, isvalid = TRUE) |> prepare_values(dm) |> attribute_values(dm)
update_item <- list(id = items$id[1], name = "Apple-update", quantity = 100, total = 0.1, isvalid = FALSE) |> prepare_values(dm) |> attribute_values(dm)
update_item_2 <- list(id = items$id[2], date = NA, name = "Banana-update", quantity = 10, total = 0.1, isvalid = TRUE) |> prepare_values(dm) |> attribute_values(dm)


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
values_extra_col <- list("id" = items[1, 'id'],
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
  saveRDS(dm, file = test_dm_url)

  # -- save items
  item_save(items, file = test_items_url)

}


# -- helper: create empty items data
create_empty_items <- function(){

  # -- create folder
  create_folder()

  # -- save data model
  saveRDS(data_model(colClasses = c(id = "numeric", date = "POSIXct")), file = test_dm_url)

  # -- save items
  item_save(items_no_row2, file = test_items_url)

}


# -- helper: create integrity test data
create_integrity_testdata <- function(){

  # -- create folder
  create_folder()

  # -- alter data model
  dm <- dm[-3, ]

  # -- save data model
  saveRDS(dm, file = test_dm_url)

  # -- save items
  item_save(items, file = test_items_url)

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

