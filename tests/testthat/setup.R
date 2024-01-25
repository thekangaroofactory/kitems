

# ------------------------------------------------------------------------------
# Declare shared objects
# ------------------------------------------------------------------------------

# -- declare colClasses
colClasses <- c(id = "numeric", date = "POSIXct", name = "character", isvalid = "logical")
colClasses_extra_att <- c(id = "numeric", date = "POSIXct", name = "character", isvalid = "logical", extra_att = "integer")
colClasses_no_date <- c(id = "numeric", name = "character", isvalid = "logical")

# -- declare default.val
default_val <- c("name" = "test", "isvalid" = TRUE)

# -- declare default.fun
default_fun <- c("date" = "Sys.Date")

# -- declare filter
filter <- c("id")

# -- declare filter
skip <- c("isvalid")

# -- declare communication object
r <- reactiveValues(dm1_data_model = 1, dm2_data_model = 2)


# ------------------------------------------------------------------------------
# Build standard objects
# ------------------------------------------------------------------------------

# -- build data model
dm <- data_model(colClasses = colClasses, default.val = default_val, default.fun = default_fun, filter = filter, skip = skip)
dm_nofilter <- data_model(colClasses = colClasses, default.val = default_val, default.fun = default_fun, filter = NULL, skip = skip)
dm_extra_att <- data_model(colClasses = colClasses_extra_att, default.val = default_val, default.fun = default_fun, filter = filter, skip = skip)
dm_no_date<- data_model(colClasses = colClasses_no_date)

# -- items
items <- data.frame("id" = c(1705158971950, 1705313192780, 1705313216662, 1705399423521),
                    "date" = c(2024-01-17, 2024-01-15, 2024-01-14, 2024-01-16),
                    "name" = c("Banana", "Apple", "Lemon", "Pear"),
                    "isvalid" = c(TRUE, FALSE, TRUE, FALSE))

# -- items with additional attribute
items_extra_att <- data.frame("id" = c(1705158971950, 1705313192780, 1705313216662, 1705399423521),
                              "date" = c(2024-01-17, 2024-01-15, 2024-01-14, 2024-01-16),
                              "name" = c("Banana", "Apple", "Lemon", "Pear"),
                              "isvalid" = c(TRUE, FALSE, TRUE, FALSE),
                              "extra_att" = c("this", "is", "an", "extra"))
