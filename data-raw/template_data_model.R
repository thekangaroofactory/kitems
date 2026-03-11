

# --------------------------------------------------------------------------
# Data Model Template
# --------------------------------------------------------------------------

# -- code to prepare package data
# run to create the data
TEMPLATE_DATA_MODEL <-

  # -- id
  attribute_create(name = "id",
                   type = "numeric",
                   default.fun = c("id" = "ktools::getTimestamp"),
                   default.arg = c("id" = "list(k=1000000)"),
                   skip = "id") |>

  # -- date & time
  attribute_create(name = "date",
                   type = "Date",
                   default.fun = c("date" = "Sys.Date"),
                   display = "date") |>

  attribute_create(name = "created_on",
                   type = "POSIXct",
                   default.fun = c("created_on" = "Sys.time"),
                   skip = "created_on") |>

  attribute_create(name = "updated_on",
                   type = "POSIXct",
                   default.fun = c("updated_on" = "Sys.time"),
                   skip = "updated_on") |>

  # -- character
  attribute_create(name = "name",
                   type = "character",
                   display = "name") |>

  attribute_create(name = "title",
                   type = "character",
                   display = "title") |>

  attribute_create(name = "description",
                   type = "character",
                   display = "description") |>

  attribute_create(name = "comment",
                   type = "character",
                   display = "comment") |>

  attribute_create(name = "note",
                   type = "character",
                   display = "note") |>

  attribute_create(name = "status",
                   type = "character",
                   display = "status") |>

  attribute_create(name = "type",
                   type = "character",
                   display = "type") |>

  attribute_create(name = "detail",
                   type = "character",
                   display = "detail") |>

  attribute_create(name = "debit",
                   type = "numeric",
                   default.val = c("debit" = 0),
                   display = "debit") |>

  attribute_create(name = "credit",
                   type = "numeric",
                   default.val = c("credit" = 0),
                   display = "credit") |>

  attribute_create(name = "amount",
                   type = "numeric",
                   default.val = c("amount" = 0),
                   display = "amount") |>

  attribute_create(name = "total",
                   type = "numeric",
                   default.val = c("total" = 0),
                   display = "total") |>

  attribute_create(name = "balance",
                   type = "numeric",
                   default.val = c("balance" = 0),
                   display = "balance") |>

  # -- integer
  attribute_create(name = "quantity",
                   type = "integer",
                   default.val = c("quantity" = 0),
                   display = "quantity") |>

  attribute_create(name = "progress",
                   type = "integer",
                   default.val = c("progress" = 0),
                   display = "progress")


# -- code to save package data
# # run to save the data
usethis::use_data(TEMPLATE_DATA_MODEL, internal = TRUE, overwrite = TRUE)
