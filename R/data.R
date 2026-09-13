

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


# --------------------------------------------------------------------------
# Declare templates:
# --------------------------------------------------------------------------

# -- Data model template
# Declaration is now in ./data-raw/template_data_model.R
