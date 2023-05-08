

# ------------------------------------------------------------------------------
# Q: how to manage rules? like defaults to auto input values?
# ------------------------------------------------------------------------------
values <- list(id = NULL,
               date = 19485,
               name = NULL,
               total = 2,
               comment = "dfsfj")

colClasses <- c("id" = "double",
                "name" = "character",
                "total" = "numeric",
                "date" = "Date",
                "comment" = "character")

default.val <- c(name = "myname",
                 total = 0)

default.fun <- c(id = getTimestamp)


# -- function definition
create_item <- function(values, colClasses, default.val, default.fun){

  # -- define list of as. functions
  CLASS_FUNCTIONS <- list("numeric" = as.numeric,
                          "integer" = as.integer,
                          "double" = as.double,
                          "character" = as.character,
                          "Date" = .Date)


  # -- fill in missing inputs with defaults
  # ----------------------------------------------------------------------------

  cat("Computing default values... \n")

  # -- helper
  helper <- function(name){

    # -- init (if no default value or fun has been submitted)
    value <- NA

    # -- check default values
    if(name %in% names(default.val))
      value <- default.val[[name]]

    # -- check default functions
    if(name %in% names(default.fun))
      value <- default.fun[[name]]()

    # -- name & return
    names(value) <- name
    cat("--", name, "=", value, "\n")
    value

  }

  # -- apply helper on NULL values
  new_values <- lapply(names(values[sapply(values, is.null)]), function(x) helper(x))

  # -- replace NULL with computed values
  values[names(unlist(new_values))] <- unlist(new_values)

  str(values)

  # -- Coerce input values to match with colClasses
  # ----------------------------------------------------------------------------

  cat("Coerce values to colClasses \n")

  str(colClasses)

  # -- helper
  helper <- function(value, class){
    cat("value =", value, "\n")
    cat("class =", class, "\n")
    CLASS_FUNCTIONS[[class]](value)}

  # -- apply helper on list of values & rename output
  item <- lapply(names(values), function(x) helper(values[[x]], colClasses[[x]]))
  names(item) <- names(values)


  # -- return a df
  # ----------------------------------------------------------------------------
  item <- as.data.frame(item)

}
