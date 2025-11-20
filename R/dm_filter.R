

#' Data Model Display
#'
#' @param data.model a data.frame containing the data model
#' @param set an optional character vector with the name of the attributes to set as hidden
#'
#' @return either the list of attributes that are hidden or an updated data model if set is not NULL
#' @export
#'
#' @details
#' If set is NULL, then the data model passed as data.model is returned
#'
#' @examples
#' \dontrun{
#' dm_display(data.model = mydatamodel, set = c("id", "internal"))
#' }


dm_display <- function(data.model, set = NULL){

  # -- test set
  if(!is.null(set)){

    # -- current, attributes to set / unset
    current <- data.model[data.model$display, ]$name
    att_set <- set[!set %in% current]
    att_unset <- current[!current %in% set]

    # -- display
    if(length(att_set) > 0){
      catl("-- display to set =", att_set)
      data.model[data.model$name %in% att_set, ]$display <- TRUE}

    # -- hide
    if(length(att_unset) > 0){
      catl("-- display to unset =", att_unset)
      data.model[data.model$name %in% att_unset, ]$display <- FALSE}

    # -- return
    return(data.model)

  } else {

    # -- check data model
    if(is.null(data.model))
      return(NULL)

    # -- get names where display TRUE
    display <- data.model[data.model$display, ]$name

    # -- check (no display in data model)
    if(identical(display, character(0)))
      display <- NULL

    # -- return
    return(display)

  }

}
