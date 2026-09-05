

# ------------------------------------------------------------------------------
# Declare shared objects
# ------------------------------------------------------------------------------

# -- declare namespace
ns <- shiny::NS("id")

# -- module id
module_id <- "myitem"


# --------------------------------------------------------------------------
# Setup test environment
# --------------------------------------------------------------------------

# -- disable traces
ktools::trace_level(0)

# -- data folder
# create & export env
testdata_path_base <- file.path(system.file("tests", "testthat", package = "kitems"), "testdata")
testdata_path <- file.path(testdata_path_base, module_id)

dir.create(testdata_path, recursive = TRUE, showWarnings = FALSE)
Sys.setenv("R_KITEMS_PATH" = testdata_path_base)

# -- urls
config_url <- name(module_id, what = "config", url = T)
items_url <- name(module_id, url = T)


# ------------------------------------------------------------------------------
# Declare objects to build data model
# ------------------------------------------------------------------------------

# most probably:
#
# make a few use cases to create test data:
# - baseline with config & items
# -
#
# Specific data will be created inside test files
# - alter baseline
# - build super specific from scratch
#
# >> keep this file as simple as possible.


# ------------------------------------------------------------------------------
# Baseline
# ------------------------------------------------------------------------------

# -- config
config <- design(project = "test",
                  item = "foo") |>
  extend(item = "foo",
         attribute = c(name = "quantity", type = "integer"),
         attribute = c(name = "total", type = "numeric"),
         attribute = c(name = "name", type = "character"),
         attribute = c(name = "date", type = "Date"),
         attribute = c(name = "isvalid", type = "logical"),
         attribute = c(name = "created", type = "POSIXct"))

# -- declare item in parent env
# so that it can be skipped
item <- "foo"

# -- data.model
dm <- yaml_to_dm(config, "name", "type", "default", "class.arg")



# ------------------------------------------------------------------------------
# Build items
# ------------------------------------------------------------------------------

values <- list(date = c(NA, "2024-01-14", "2024-01-16", "2024-01-17"),
               name = c("Apple", "Banana", "Mango", "Orange"),
               quantity = c(1, 12, 3, 7),
               total = c(12.5, 106.3, 45.7, 17.5),
               isvalid = c(TRUE, FALSE, TRUE, FALSE),
               created = replicate(4, Sys.time()))

# -- build base items
items <- values |>
  prepare_values(config) |>
  attribute_values(dm) |>
  rows_insert(data.frame())

# -- items with additional attribute
# items_extra_att <- items
#items_extra_att$extra_att <- c("this", "is", "an", "extra")

# -- items without row
items_no_row <- data.frame("id" = as.numeric(numeric()),
                           "name" = as.character(character()))
items_no_row2 <- data.frame("id" = as.numeric(numeric()),
                            "date" = as.character(character()))

# -- items to test triggers
#new_item <- list(name = "Raspberry", quantity = 34, total = 86.4, isvalid = TRUE) |> prepare_values(dm) |> attribute_values(dm)
#update_item <- list(id = items$id[1], name = "Apple-update", quantity = 100, total = 0.1, isvalid = FALSE) |> prepare_values(dm) |> attribute_values(dm)
#update_item_2 <- list(id = items$id[2], date = NA, name = "Banana-update", quantity = 10, total = 0.1, isvalid = TRUE) |> prepare_values(dm) |> attribute_values(dm)


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

# -- simulate inputs from form
item_input_values <- list(name = "myname", quantity = 12, total = 34.8)

# -- date selection
date_slider_value <- c(as.POSIXct(as.Date("2024-01-15")), as.POSIXct(as.Date("2024-01-17")))


# --------------------------------------------------------------------------
# Declare helper functions
# --------------------------------------------------------------------------

# -- helper: create test data
create_testdata <- function(){

  # -- config
  config_write(config)

  # -- items
  item_save(items,  connector = list(file = items_url))

}


# -- helper: create empty items data
create_empty_items <- function(){

  # -- YAML
  config_write(c_create(project = "test"))

  # -- save items
  item_save(items_no_row2,  connector = list(file = items_url))

}


# -- helper: create integrity test data
create_integrity_testdata <- function(){

  # -- alter data model
  dm <- dm[-3, ]

  # -- save data model
  saveRDS(dm, file = test_dm_url)

  # -- save items
  item_save(items,  connector = list(file = items_url))

}


# -- helper: cleanup function
clean_all <- function(){

  unlink(testdata_path_base, recursive = TRUE)

}

