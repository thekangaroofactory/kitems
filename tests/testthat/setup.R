

# ------------------------------------------------------------------------------
# Declare shared objects
# ------------------------------------------------------------------------------

# -- declare namespace
ns <- shiny::NS("id")

# -- module id
module_id <- "data"

# -- declare communication object
r <- reactiveValues()


# --------------------------------------------------------------------------
# Setup test environment
# --------------------------------------------------------------------------

# -- create testdata folder
testdata_path <- file.path(system.file("tests", "testthat", package = "kitems"), "testdata")

# ******************** TO BE DELETED
test_path = list(data = testdata_path,
                 resource = testdata_path)


# ------------------------------------------------------------------------------
# Declare objects to build data model
# ------------------------------------------------------------------------------

# -- declare colClasses
colClasses <- c(id = "double", date = "POSIXct", name = "character", quantity = "integer", total = "numeric", isvalid = "logical")
colClasses_extra_att <- c(colClasses, extra_att = "integer")
colClasses_no_date <- colClasses[!names(colClasses) %in% "date"]

# -- declare default.val
default_val <- c("name" = "fruit", "isvalid" = TRUE)

# -- declare default.fun
default_fun <- c("id" = "ktools::getTimestamp", "date" = "Sys.Date")

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


# ------------------------------------------------------------------------------
# Build items
# ------------------------------------------------------------------------------

# -- build base items
items <- item_create(list(id = NA, date = NA, name = "Apple", quantity = 1, total = 12.5, isvalid = TRUE), dm)
new_item <- item_create(list(id = NA, date = "2024-01-14", name = "Banana", quantity = 12, total = 106.3, isvalid = FALSE), dm)
items <- item_add(items, new_item)
new_item <- item_create(list(id = NA, date = "2024-01-16", name = "Mango", quantity = 3, total = 45.7, isvalid = TRUE), dm)
items <- item_add(items, new_item)
new_item <- item_create(list(id = NA, date = "2024-01-17", name = "Orange", quantity = 7, total = 17.5, isvalid = FALSE), dm)
items <- item_add(items, new_item)

# -- items with additional attribute
items_extra_att <- items
items_extra_att$extra_att <- c("this", "is", "an", "extra")

# -- items without row
items_no_row <- data.frame("id" = as.numeric(numeric()),
                           "name" = as.character(character()))

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
date_slider_value <- c(19737, 19739)


# --------------------------------------------------------------------------
# Declare helper functions
# --------------------------------------------------------------------------

# -- helper: build data model
create_testdata <- function(){

  # -- create folder
  dir.create(testdata_path)

  # -- save data model
  dm_url <- file.path(testdata_path, paste0(dm_name(module_id), ".rds"))
  saveRDS(dm, file = dm_url)

  # -- save items
  item_save(items, file = "my_data.csv", path = testdata_path)

}


# -- helper: cleanup function
clean_all <- function(testdata_path){

  unlink(testdata_path, recursive = TRUE)

}

