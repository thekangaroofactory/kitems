

#' Search Items
#'
#' @description
#' A simple wrapper around \link[dplyr]{filter} function
#'
#' @param items a data.frame of items
#' @param pattern the search pattern
#'
#' @return a filtered data.frame
#' @export
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#' @importFrom dplyr if_any
#'
#' @details
#' The function is not intended to perform any smart or advanced search. \cr
#' It provides basic search across all except \code{id} attributes.
#'
#' Basically it returns \code{filter(items, if_any(-(id), ~ grepl(pattern, .)))}
#'
#' @examples
#' \dontrun{
#' item_search(items = mydata$items(), pattern = "Banana")
#' item_search(items = mydata$items(), pattern = 25)
#' }

item_search <- function(items, pattern){

  # -- check for empty string (otherwise the whole df is returned)
  if(identical(pattern, ""))
    return(NULL)

  cat("[item_search] Search pattern =", pattern, "\n")

  # -- filter items
  result <- items %>%
    filter(if_any(-(id), ~ grepl(pattern, .)))

  # -- check
  cat("[item_search] output dim =", dim(result), "\n")

  # -- return
  as.data.frame(result)

}
