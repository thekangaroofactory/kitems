

# --------------------------------------------------------------------------
# Data Model Template
# --------------------------------------------------------------------------

# -- code to prepare package data
# run to create the data
TEMPLATE_DATA_MODEL <-

  # -- id
  attribute_create(name = "id",
                   class = "numeric",
                   default.fun = "ktools::getTimestamp",
                   default.arg = "list(k=1000000)",
                   skip = TRUE,
                   display = FALSE) |>

  # -- date & time
  attribute_create(name = "date",
                   class = "Date",
                   default.fun = "Sys.Date") |>

  attribute_create(name = "created_on",
                   class = "POSIXct",
                   default.fun = "Sys.time",
                   skip = TRUE) |>

  attribute_create(name = "updated_on",
                   class = "POSIXct",
                   default.fun = "Sys.time",
                   skip = TRUE,
                   refresh = TRUE) |>

  # -- character
  attribute_create(name = "name",
                   class = "character") |>

  attribute_create(name = "title",
                   class = "character") |>

  attribute_create(name = "description",
                   class = "character") |>

  attribute_create(name = "comment",
                   class = "character") |>

  attribute_create(name = "note",
                   class = "character") |>

  attribute_create(name = "status",
                   class = "character") |>

  attribute_create(name = "type",
                   class = "character") |>

  attribute_create(name = "detail",
                   class = "character") |>

  attribute_create(name = "debit",
                   class = "numeric",
                   default.val = 0) |>

  attribute_create(name = "credit",
                   class = "numeric",
                   default.val = 0) |>

  attribute_create(name = "amount",
                   class = "numeric",
                   default.val = 0) |>

  attribute_create(name = "total",
                   class = "numeric",
                   default.val = 0) |>

  attribute_create(name = "balance",
                   class = "numeric",
                   default.val = 0) |>

  # -- integer
  attribute_create(name = "quantity",
                   class = "integer",
                   default.val = 0) |>

  attribute_create(name = "progress",
                   class = "integer",
                   default.val = 0)


# -- code to save package data
# # run to save the data
usethis::use_data(TEMPLATE_DATA_MODEL, internal = TRUE, overwrite = TRUE)
