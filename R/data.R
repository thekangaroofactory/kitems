

# --------------------------------------------------------------------------
# Package internal data
# This file is created based on description for internal data:
# https://r-pkgs.org/data.html#sec-data-sysdata
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# Declare supported types:
# --------------------------------------------------------------------------

# -- Object types (supported)
# removed double #218
OBJECT_CLASS <- c("numeric",
                  "integer",
                  "logical",
                  "character",
                  "Date",
                  "POSIXct")

# -- Define list of as functions
# Note: replacing .Date by as.Date #588 (see issue)
CLASS_FUNCTIONS <- list("numeric" = "as.numeric",
                        "integer" = "as.integer",
                        "logical" = "as.logical",
                        "character" = "as.character",
                        "Date" = "as.Date",
                        "POSIXct" = "as.POSIXct")

# -- Define list of examples #281
CLASS_EXAMPLES <- list("numeric" = 10.5,
                       "integer" = 2,
                       "logical" = TRUE,
                       "character" = "mango",
                       "Date" = as.Date(Sys.Date()),
                       "POSIXct" = as.POSIXct(Sys.time()))


# --------------------------------------------------------------------------
# Declare config parameters:
# --------------------------------------------------------------------------

# -- Default values
DEFAULT_VALUES <- list("numeric" = 0,
                       "integer" = 0,
                       "logical" = FALSE,
                       "character" = "",
                       "Date" = Sys.Date(),
                       "POSIXct" = Sys.time())

# -- Default functions
DEFAULT_FUNCTIONS <- list("numeric" = NULL,
                          "integer" = NULL,
                          "logical" = NULL,
                          "character" = NULL,
                          "Date" = "Sys.Date()",
                          "POSIXct" = c("Sys.time()", "Sys.Date()"))


# --------------------------------------------------------------------------
# Declare data model structure:
# --------------------------------------------------------------------------

# -- version
# this is the latest package version introducing a data model upgrade
DATA_MODEL_VERSION <- "0.8.0"

# -- colClasses
# this is used to check data.model integrity
DATA_MODEL_COLCLASSES <- list(name = "character",
                              type = "character",
                              class.arg = "character",
                              values = "character",
                              default.val = "character",
                              default.fun = "character",
                              display = "logical",
                              skip = "logical",
                              refresh = "logical",
                              sort.rank = "numeric",
                              sort.desc = "logical")

# -- default values
# this is used for data.mode migration
DATA_MODEL_DEFAULTS <- list(name = NA,
                            type = NA,
                            class.arg = NA,
                            values = NA,
                            default.val = NA,
                            default.fun = NA,
                            display = FALSE,
                            skip = FALSE,
                            refresh = FALSE,
                            sort.rank = NA,
                            sort.desc = NA)


# --------------------------------------------------------------------------
# Declare templates:
# --------------------------------------------------------------------------

# -- Data model template
# Declaration is now in ./data-raw/template_data_model.R
