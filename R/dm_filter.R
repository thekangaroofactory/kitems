

#' Data model attribute filter
#'
#' @param data.model a data.frame containing the data model
#' @param set an optional character vector with the name of the attributes to set as filtered
#'
#' @return either the list of attributes that are filtered or an updated data model if set is not NULL
#' @export
#'
#' @details
#' If filter is NULL, then the data model passed as data.model is returned
#'
#' @examples
#' \dontrun{
#' dm_filter(data.model = mydatamodel, filter = c("id", "internal"))
#' }


dm_filter <- function(data.model, set = NULL){

  # -- test set
  if(!is.null(set)){

    # -- current filters, attributes to set / unset
    current_filter <- data.model[data.model$filter, ]$name
    att_set <- set[!set %in% current_filter]
    att_unset <- current_filter[!current_filter %in% set]

    # -- filter
    if(length(att_set) > 0){
      cat("-- filter to set =", att_set, "\n")
      data.model[data.model$name %in% att_set, ]$filter <- TRUE}

    # -- un-filter
    if(length(att_unset) > 0){
      cat("-- filter to unset =", att_unset, "\n")
      data.model[data.model$name %in% att_unset, ]$filter <- FALSE}

    # -- return
    return(data.model)

  } else {

    # -- check data model
    if(is.null(data.model))
      return(NULL)

    # -- get names where filter TRUE
    filter <- data.model[data.model$filter, ]$name

    # -- check (no filter in data model)
    if(identical(filter, character(0)))
      filter <- NULL

    # -- return
    return(filter)

  }

}
