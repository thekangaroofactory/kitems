

# --------------------------------------------------------------------------
# Data Model Template
# --------------------------------------------------------------------------

# -- code to prepare package data
# run to create the data
TEMPLATE_DATA_MODEL <-

  # -- id
  attribute_create(name = "id",
                   type = "numeric",
                   default.fun = "ktools::getTimestamp",
                   default.arg = "list(k=1000000)",
                   skip = TRUE,
                   display = FALSE) |>

  # -- date & time
  attribute_create(name = "date",
                   type = "Date",
                   default.fun = "Sys.Date") |>

  attribute_create(name = "created_on",
                   type = "POSIXct",
                   default.fun = "Sys.time",
                   skip = TRUE) |>

  attribute_create(name = "updated_on",
                   type = "POSIXct",
                   default.fun = "Sys.time",
                   skip = TRUE,
                   refresh = TRUE) |>

  # -- character
  attribute_create(name = "name",
                   type = "character") |>

  attribute_create(name = "title",
                   type = "character") |>

  attribute_create(name = "description",
                   type = "character") |>

  attribute_create(name = "comment",
                   type = "character") |>

  attribute_create(name = "note",
                   type = "character") |>

  attribute_create(name = "status",
                   type = "character") |>

  attribute_create(name = "type",
                   type = "character") |>

  attribute_create(name = "detail",
                   type = "character") |>

  attribute_create(name = "debit",
                   type = "numeric",
                   default.val = 0) |>

  attribute_create(name = "credit",
                   type = "numeric",
                   default.val = 0) |>

  attribute_create(name = "amount",
                   type = "numeric",
                   default.val = 0) |>

  attribute_create(name = "total",
                   type = "numeric",
                   default.val = 0) |>

  attribute_create(name = "balance",
                   type = "numeric",
                   default.val = 0) |>

  # -- integer
  attribute_create(name = "quantity",
                   type = "integer",
                   default.val = 0) |>

  attribute_create(name = "progress",
                   type = "integer",
                   default.val = 0)


# -- code to save package data
# # run to save the data
usethis::use_data(TEMPLATE_DATA_MODEL, internal = TRUE, overwrite = TRUE)
