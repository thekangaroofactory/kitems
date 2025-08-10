

#' Build list of input values
#'
#' @param input the input object from the shiny module
#' @param colClasses a named vector of classes, defining the data model
#'
#' @return a named list of values
#' @export
#'
#' @details the output list will contain as many entries as the colClasses named vector.
#' In case some names have no corresponding item in the input parameter, they will get NULL as value
#' in the output list.
#'
#' @examples
#' \dontrun{
#' values <- item_input_values(input, colClasses = c("date" = "Date", "text" = "character"))
#' }


# -- function definition
item_input_values <- function(input, colClasses){

  # -- get values from input object
  # input is a reactive object, can't use input[names(colClasses)]
  values <- lapply(names(colClasses), function(x) input[[x]])
  names(values) <- names(colClasses)

  # -- case POSIXct
  # Need to retrieve additional time & timezone inputs
  if(any(colClasses == "POSIXct")){

    catl("[item_input_values] Need to retrieve additional time & timezone inputs")

    # -- get attributes
    att_names <- names(colClasses)[colClasses == "POSIXct"]

    # -- helper function
    helper <- function(name){

      catl("Attribute =", name, level = 2)

      # -- check NULL
      # when main/date value is NULL, then time & timzone shoudl be skipped #427
      value <- if(is.null(values[[name]])){

        catl("-- Date value is NULL, skipping time & timezone", level = 2)
        NULL

      } else {

        # -- retrieve extra inputs
        att_time <- paste0(name, "_time")
        att_tz <- paste0(name, "_tz")

        extra_values <- lapply(c(att_time, att_tz), function(x) input[[x]])
        names(extra_values) <- c(att_time, att_tz)

        catl("-- time =", extra_values[[att_time]], 2)
        catl("-- timezone =", extra_values[[att_tz]], 2)

        # -- compute real value from all inputs
        value <- eval(call(CLASS_FUNCTIONS[[colClasses[name]]], paste(as.character(values[[name]]), extra_values[[att_time]]), tz = extra_values[[att_tz]]))

      }

      catl("- Attribute =", name, "/ value =", class(value), value)

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
