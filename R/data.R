

# --------------------------------------------------------------------------
# Declare supported types:
# --------------------------------------------------------------------------

# -- Object types (supported)
# removed double #218
OBJECT_CLASS <- c("numeric",
                  "integer",
                  "logical",
                  "character",
                  "factor",
                  "Date",
                  "POSIXct")

# -- Define list of as functions
CLASS_FUNCTIONS <- list("numeric" = "as.numeric",
                        "integer" = "as.integer",
                        "logical" = "as.logical",
                        "character" = "as.character",
                        "factor" = "as.factor",
                        "Date" = ".Date",
                        "POSIXct" = "as.POSIXct")

# -- Define list of examples #281
CLASS_EXAMPLES <- list("numeric" = 10.5,
                       "integer" = 2,
                       "logical" = TRUE,
                       "character" = "mango",
                       "factor" = "- (NA, a factor can't be displayed here)",
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
                       "factor" = NULL,
                       "Date" = Sys.Date(),
                       "POSIXct" = Sys.time())

# -- Default functions
DEFAULT_FUNCTIONS <- list("numeric" = NULL,
                          "integer" = NULL,
                          "logical" = NULL,
                          "character" = NULL,
                          "factor" = NULL,
                          "Date" = "Sys.Date",
                          "POSIXct" = c("Sys.time", "Sys.Date"))


# --------------------------------------------------------------------------
# Declare data model structure:
# --------------------------------------------------------------------------

# -- colClasses
DATA_MODEL_COLCLASSES <- list(name = "character",
                              type = "character",
                              default.val = "character",
                              default.fun = "character",
                              default.arg = "character",
                              filter = "logical",
                              skip = "logical",
                              sort.rank = "numeric",
                              sort.desc = "logical")

# -- default values
DATA_MODEL_DEFAULTS <- list(name = NA,
                            type = NA,
                            default.val = NA,
                            default.fun = NA,
                            default.arg = NA,
                            filter = FALSE,
                            skip = FALSE,
                            sort.rank = NA,
                            sort.desc = NA)


# --------------------------------------------------------------------------
# Declare templates:
# --------------------------------------------------------------------------

# -- Data model template
# Extend template to all data model parameters #220
TEMPLATE_DATA_MODEL <- data.frame(name = c("date",
                                           "name", "title", "description", "comment", "note", "status", "detail",
                                           "id", "debit", "credit", "amount", "total", "balance",
                                           "quantity", "progress"),

                                  type = c("Date",
                                           rep("character", 7),
                                           rep("numeric", 6),
                                           rep("integer", 2)),

                                  # -- added #220
                                  default.val = c(NA,
                                                  rep(NA, 7),
                                                  NA, rep(0, 5),
                                                  rep(0, 2)),

                                  # -- added #220
                                  default.fun = c("Sys.Date",
                                                  rep(NA, 7),
                                                  "ktools::getTimestamp", rep(NA, 5),
                                                  rep(NA, 2)),

                                  # -- added #63
                                  default.arg = rep(NA, 16),

                                  # -- added #220
                                  filter = c(FALSE,
                                             rep(FALSE, 7),
                                             TRUE, rep(FALSE, 5),
                                             rep(FALSE, 2)),

                                  # -- added #220
                                  skip = c(FALSE,
                                           rep(FALSE, 7),
                                           TRUE, rep(FALSE, 5),
                                           rep(FALSE, 2)),

                                  # -- added #239
                                  sort.rank = rep(NA, 16),

                                  # -- added #239
                                  sort.desc = rep(NA, 16))

