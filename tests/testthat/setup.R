

# ------------------------------------------------------------------------------
# Declare shared objects
# ------------------------------------------------------------------------------

# -- namespace
ns <- shiny::NS("id")

# -- module id
module_id <- "foo"


# --------------------------------------------------------------------------
# Setup test environment
# --------------------------------------------------------------------------

# -- disable traces
ktools::trace_level(0)

# -- data folder
testdata_path_base <- file.path(system.file("tests", "testthat", package = "kitems"), "testdata")
testdata_path <- file.path(testdata_path_base, module_id)

# -- helper
create_test_folder <- function(x)
  dir.create(x, recursive = TRUE, showWarnings = FALSE)

# -- create & set env
create_test_folder(testdata_path)
Sys.setenv("R_KITEMS_PATH" = testdata_path_base)

# -- urls
config_url <- name(module_id, what = "config", url = T)
items_url <- name(module_id, url = T)


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
# to pass to some workflow functions
dm <- yaml_to_dm(config, "name", "type", "default", "class.arg")


# ------------------------------------------------------------------------------
# Build items
# ------------------------------------------------------------------------------

# -- inputs
values <- list(date = c(NA, "2024-01-14", "2024-01-16", "2024-01-17"),
               name = c("Apple", "Banana", "Mango", "Orange"),
               quantity = c(1, 12, 3, 7),
               total = c(12.5, 106.3, 45.7, 17.5),
               isvalid = c(TRUE, FALSE, TRUE, FALSE),
               created = replicate(4, Sys.time()))

# -- build items
items <- values |>
  prepare_values(config, item = "foo") |>
  attribute_values(dm) |>
  rows_insert(data.frame())


# --------------------------------------------------------------------------
# Declare helper functions
# --------------------------------------------------------------------------

# -- helper: create test data
create_testdata <- function(){

  # folder
  create_test_folder(testdata_path)

  # config
  config_write(config)

  # items
  item_save(items,  connector = list(file = items_url))

}

# -- helper: cleanup function
clean_all <- function(){

  unlink(testdata_path_base, recursive = TRUE)

}
