

# --------------------------------------------------------------------------
# Declare supported types:
# --------------------------------------------------------------------------

# -- Object types (supported)
OBJECT_CLASS <- c("numeric",
                  "integer",
                  "double",
                  "logical",
                  "character",
                  "factor",
                  "Date",
                  "POSIXct",
                  "POSIXlt")


# --------------------------------------------------------------------------
# Declare config parameters:
# --------------------------------------------------------------------------

# -- Default values
DEFAULT_VALUES <- list("numeric" = c(NA, 0),
                       "integer" = c(NA, 0),
                       "double" = c(NA, 0),
                       "logical" = c(NA, FALSE, TRUE),
                       "character" = c(NA, ""),
                       "factor" = c(NA),
                       "Date" = c(NA),
                       "POSIXct" = c(NA),
                       "POSIXlt" = c(NA))

# -- Default functions
DEFAULT_FUNCTIONS <- list("numeric" = c(NA),
                          "integer" = c(NA),
                          "double" = c(NA),
                          "logical" = c(NA),
                          "character" = c(NA),
                          "factor" = c(NA),
                          "Date" = c("Sys.Date"),
                          "POSIXct" = c("Sys.Date"),
                          "POSIXlt" = c("Sys.Date"))


# --------------------------------------------------------------------------
# Declare templates:
# --------------------------------------------------------------------------

# -- Data model template
TEMPLATE_DATA_MODEL <- data.frame(name = c("date",
                                           "name", "title", "description", "comment", "note", "status", "detail",
                                           "debit", "credit", "amount", "total", "balance",
                                           "quantity", "progress"),
                                  type = c("Date",
                                           rep("character", 7),
                                           rep("double", 5),
                                           rep("integer", 2)))
