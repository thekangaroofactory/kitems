

# ------------------------------------------------------------------------------
# Declare shared objects
# ------------------------------------------------------------------------------

# -- declare colClasses
colClasses <- c(id = "numeric", date = "POSIXct", name = "character", isvalid = "logical")

# -- declare default.val
default_val <- c("name" = "test", "isvalid" = TRUE)

# -- declare default.fun
default_fun <- c("date" = "Sys.Date")

# -- declare filter
filter <- c("id" = TRUE)

# -- declare filter
skip <- c("isvalid" = TRUE)


# ------------------------------------------------------------------------------
# Build standard objects
# ------------------------------------------------------------------------------

# -- build data model
dm <- data_model(colClasses = colClasses, default.val = default_val, default.fun = default_fun, filter = filter, skip = skip)

# -- items
items <- data.frame("id" = c(1705158971950, 1705313192780, 1705313216662, 1705399423521),
                    "date" = c(2024-01-17, 2024-01-15, 2024-01-14, 2024-01-16),
                    "name" = c("Banana", "Apple", "Lemon", "Pear"),
                    "isvalid" = c(TRUE, FALSE, TRUE, FALSE))
