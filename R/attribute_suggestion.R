

#' Attribute Suggestions
#'
#' @param values a vector of values, most probably a vector corresponding to one of the item data frame columns
#' @param type an optional character vector, the type (class) of values. If not provided, class(values) will be used
#' @param n the desired number of suggestions. This applies only on character, factor, numeric & integer types
#' @param floor a numeric value. This applies only for numeric & integer types. If none of the value frequency (in %)
#' reaches \code{floor}, then basic suggestions are returned (see details)
#'
#' @details
#' For numeric & integer values, the default strategy is to compute the \code{n} most frequent occurrences.
#' If no occurrence reaches the \code{floor} level (% of all items), then the standard list is returned.
#'
#' @return a list of suggestions
#' This list depends on the \code{type} of values
#'
#' - character, factor:
#' the most frequent values ; \code{list(value1 = frequency, value_2, = frequency)}
#'
#' - numeric, integer:
#' the most frequent values ; \code{list(value1 = frequency, value_2, = frequency)}, or
#' a standard list ; \code{list(min, max, mean, median)}
#'
#' - logical:
#' the frequency for both values ; \code{list(true = frequency, false = frequency)}
#'
#' - Date, POSIXct:
#' a standard list ; \code{list(min, max)}
#'
#' @export
#'
#' @examples
#' foo <- c(rep("banana", 5) rep("mango", 3), rep("orange", 2))
#' attribute_suggestion <- function(values = foo, type = "character)

attribute_suggestion <- function(values, type = class(values), n = 3, floor = 10){

  # -- init
  suggestions <- NULL

  # -- character
  if(type %in% c("character", "factor")){
    suggestions <- as.list(head(sort(table(values), decreasing = TRUE), n = n))
    suggestions <- lapply(suggestions, function(x) round(x / length(values) * 100))}

  # -- numeric, integer
  if(type %in% c("numeric", "integer")){

    # -- try by frequencies
    suggestions <- as.list(head(sort(table(values), decreasing = TRUE), n = n))
    suggestions <- lapply(suggestions, function(x) round(x / length(values) * 100))

    # -- switch to basic suggestions if occurrences < floor
    if(!any(suggestions > floor))
      suggestions <- list(min = min(values), max = max(values), mean = mean(values), median = median(values))}

  # -- logical
  if(type == "logical")
    suggestions <- list(true = round(sum(values) / length(values) * 100), false = round(sum(!values) / length(values) * 100))

  # -- Date, POSIXct
  if(type %in% c("Date", "POSIXct"))
    suggestions <- list(min = min(values), max = max(values))

  # -- return
  suggestions

}
