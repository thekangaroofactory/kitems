

#' Set data model attribute filter
#'
#' @param data.model a data.frame containing the data model
#' @param filter a character vector with the name of the attributes to be filtered
#'
#' @return an updated data model
#' @export
#'
#' @details
#' If filter is NULL, then the data model passed as data.model is returned
#'
#' @examples
#' \dontrun{
#' dm_filter_set(data.model = mydatamodel, filter = c("id", "internal"))
#' }


dm_filter_set <- function(data.model, filter){

  # -- test filter
  if(!is.null(filter)){

    # -- current filters
    current_filter <- data.model[data.model$filter, ]$name

    # -- attributes to filter
    att_set <- filter[!filter %in% current_filter]
    if(length(att_set) > 0){
      cat("-- filter to set =", att_set, "\n")
      data.model[data.model$name %in% att_set, ]$filter <- TRUE}

    # -- attributes to un-filter
    att_unset <- current_filter[!current_filter %in% filter]
    if(length(att_unset) > 0){
      cat("-- filter to unset =", att_unset, "\n")
      data.model[data.model$name %in% att_unset, ]$filter <- FALSE}

  }

  # -- Return
  data.model

}
