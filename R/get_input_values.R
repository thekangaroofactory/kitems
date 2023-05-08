

#' Build list of input values
#'
#' @param input the input object from the shiny module
#' @param colClasses a named vector of classes, defining the data model
#'
#' @return a list of values
#'
#' @examples


# -- function definition
get_input_values <- function(input, colClasses){

  # -- get values from input object
  values <- lapply(names(colClasses, function(x) input[[x]]))

  # -- name the list
  names(values) <- names(colClasses)

  # -- return
  values

}
