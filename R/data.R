

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


# --------------------------------------------------------------------------
# Declare config parameters:
# --------------------------------------------------------------------------

# -- Default values
DEFAULT_VALUES <- list("numeric" = c(NA, 0),
                       "integer" = c(NA, 0),
                       "logical" = c(NA, FALSE, TRUE),
                       "character" = c(NA, ""),
                       "factor" = c(NA),
                       "Date" = c(NA),
                       "POSIXct" = c(NA))

# -- Default functions
DEFAULT_FUNCTIONS <- list("numeric" = c(NA),
                          "integer" = c(NA),
                          "logical" = c(NA),
                          "character" = c(NA),
                          "factor" = c(NA),
                          "Date" = c("Sys.Date"),
                          "POSIXct" = c("Sys.Date", "Sys.time"))


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

