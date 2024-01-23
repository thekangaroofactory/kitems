

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
#' values <- get_input_values(input, colClasses = c("date" = "Date", "text" = "character"))


# -- function definition
get_input_values <- function(input, colClasses){

  # -- get values from input object
  values <- lapply(names(colClasses), function(x) input[[x]])

  # -- name the list
  names(values) <- names(colClasses)

  # -- return
  values

}
