

# ------------------------------------------------------------------------------
# Declare shared objects
# ------------------------------------------------------------------------------

# -- declare colClasses
colClasses <- c(id = "numeric", date = "POSIXct", name = "character", isvalid = "logical")
colClasses_extra_att <- c(id = "numeric", date = "POSIXct", name = "character", isvalid = "logical", extra_att = "integer")
colClasses_no_date <- c(id = "numeric", name = "character", isvalid = "logical")
colClasses_test_file <- c(id = "double", name = "character", total = "numeric", comment = "character", date = "Date")

# -- declare default.val
default_val <- c("name" = "test", "isvalid" = TRUE)

# -- declare default.fun
default_fun <- c("date" = "Sys.Date")

# -- declare filter
filter <- c("id")

# -- declare filter
skip <- c("isvalid")

# -- declare communication object
r <- reactiveValues(dm1_data_model = 1, dm2_data_model = 2)

# -- declare namespace
ns <- shiny::NS("id")

# -- module id
module_id <- "data"

# -- data path
path <- list(data = system.file("shiny-examples", "demo", "data", package = "kitems"),
             resource = system.file("shiny-examples", "demo", "data", package = "kitems"))
path_test_output <- file.path(system.file("tests", "testthat", package = "kitems"), "testdata")

# -- test file
test_file <- "my_data_2.csv"
test_file_output <- "item_save_output.csv"

# ------------------------------------------------------------------------------
# Build standard objects
# ------------------------------------------------------------------------------

# -- build data model
dm <- data_model(colClasses = colClasses, default.val = default_val, default.fun = default_fun, filter = filter, skip = skip)
dm_nofilter <- data_model(colClasses = colClasses, default.val = default_val, default.fun = default_fun, filter = NULL, skip = skip)
dm_no_skip <- data_model(colClasses = colClasses, default.val = default_val, default.fun = default_fun, filter = filter, skip = NULL)
dm_extra_att <- data_model(colClasses = colClasses_extra_att, default.val = default_val, default.fun = default_fun, filter = filter, skip = skip)
dm_no_date <- data_model(colClasses = colClasses_no_date)
dm_test_file <- data_model(colClasses = colClasses_test_file)

# -- items
items <- data.frame("id" = c(1705158971950, 1705313192780, 1705313216662, 1705399423521),
                    "date" = c(as.Date("2024-01-17", origin = "01-01-1970"), as.Date("2024-01-15", origin = "01-01-1970"), as.Date("2024-01-14", origin = "01-01-1970"), as.Date("2024-01-16", origin = "01-01-1970")),
                    "name" = c("Banana", "Apple", "Lemon", "Pear"),
                    "isvalid" = c(TRUE, FALSE, TRUE, FALSE))

# -- items with additional attribute
items_extra_att <- data.frame("id" = c(1705158971950, 1705313192780, 1705313216662, 1705399423521),
                              "date" = c(as.Date("2024-01-17", origin = "01-01-1970"), as.Date("2024-01-15", origin = "01-01-1970"), as.Date("2024-01-14", origin = "01-01-1970"), as.Date("2024-01-16", origin = "01-01-1970")),
                              "name" = c("Banana", "Apple", "Lemon", "Pear"),
                              "isvalid" = c(TRUE, FALSE, TRUE, FALSE),
                              "extra_att" = c("this", "is", "an", "extra"))

# -- items without row
items_no_row <- data.frame("id" = as.numeric(numeric()),
                           "name" = as.character(character()))

# -- new item
item_new <- data.frame("id" = c(170539948521),
                       "date" = c(as.Date("2024-01-25", origin = "01-01-1970")),
                       "name" = c("Mango"),
                       "isvalid" = c(TRUE))

# -- new item (trigger)
item_new_2 <- data.frame("id" = c(170539948521),
                         "name" = c("Mango"),
                         "total" = 12,
                         "comment" = "server added",
                         "date" = c(as.Date("2024-01-25", origin = "01-01-1970")))

# -- item update
item_update <- data.frame("id" = c(1705313192780),
                       "date" = c(as.Date("2024-01-01", origin = "01-01-1970")),
                       "name" = c("Apple-update"),
                       "isvalid" = c(TRUE))

# -- new update (trigger)
item_update_2 <- data.frame("id" = c(1705313192780),
                            "name" = c("Apple update"),
                            "total" = 1,
                            "comment" = "server updated",
                            "date" = c(as.Date("2024-01-01", origin = "01-01-1970")))

# -- values to create attribute
values <- list("id" = c(170539948621),
               "date" = c(as.Date("2024-01-25", origin = "01-01-1970")),
               "name" = c("Orange"),
               "isvalid" = c(FALSE))

# -- item id (to delete)
item_id <- 1705313192780


# -- date selection
date_slider_value <- c(19737, 19739)


# -- cleanup function
clean_all <- function(testdata_path){

  unlink(testdata_path, recursive = TRUE)

}


