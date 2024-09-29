

#' Build list of input values
#'
#' @param input the input object from the shiny module
#' @param colClasses a named vector of classes, defining the data model
#'
#' @return a list of values
#'
#' @details the output list will contain as many entries as the colClasses named vector.
#' In case some names have no corresponding item in the input parameter, they will get NULL as value
#' in the output list.
#'
#' @examples
#' \dontrun{
#' values <- get_input_values(input, colClasses = c("date" = "Date", "text" = "character"))
#' }


# -- function definition
get_input_values <- function(input, colClasses){

  # -- get values from input object
  values <- lapply(names(colClasses), function(x) input[[x]])
  names(values) <- names(colClasses)

  # -- case POSIXct & POSIXlt
  # Need to retrieve additional time & timezone inputs
  if(any(colClasses %in% c("POSIXct", "POSIXlt"))){

    cat("[get_input_values] Need to retrieve additional time & timezone inputs \n")

    # -- get attributes
    att_names <- names(colClasses)[colClasses %in% c("POSIXct", "POSIXlt")]

    # -- helper function
    helper <- function(name){

      # -- retrieve extra inputs
      att_time <- paste0(name, "_time")
      att_tz <- paste0(name, "_tz")

      extra_values <- lapply(c(att_time, att_tz), function(x) input[[x]])
      names(extra_values) <- c(att_time, att_tz)

      # -- compute real value from all inputs

      # as.POSIXct(paste(as.character(values[name]), extra_values[att_time]), tz = extra_values[att_tz])

      # bar <- strptime(paste(as.character(values[[name]]), extra_values[[att_time]]), format = "%Y-%m-%d %H:%M:%S", tz = extra_values[[att_tz]])
      # str(bar)

      value <- eval(call(CLASS_FUNCTIONS[[colClasses[name]]], paste(as.character(values[[name]]), extra_values[[att_time]]), tz = extra_values[[att_tz]]))
      cat("- Attribute =", name, "/ value =", class(value), value, "\n")

      # -- return
      value

    }

    # -- apply & rename output
    att_values <- lapply(att_names, helper)
    names(att_values) <- att_names

    # -- warning! use of sapply or unlist would turn POSIX* into numeric!
    att_values <- do.call("c", att_values)

    # -- replace attribute values
    values[att_names] <- list(att_values)

  }

  # -- return
  values

}
