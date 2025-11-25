

#' Search Items
#'
#' @description
#' A simple wrapper around \link[dplyr]{filter} function.
#'
#' @param items a data.frame of items.
#' @param pattern the search pattern.
#'
#' @return A filtered data.frame.
#' @export
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#' @importFrom dplyr if_any
#' @importFrom rlang .data
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

  catl("[item_search] Search pattern =", pattern)

  # -- filter items
  # using .data from rlang to access the id column
  # otherwise check() would complain about global variable!
  result <- items %>%
    filter(if_any(-("id"), ~ grepl(pattern, .)))

  # -- check
  catl("[item_search] output dim =", dim(result))

  # -- return
  as.data.frame(result)

}
