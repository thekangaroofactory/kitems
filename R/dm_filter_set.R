

#' Title
#'
#' @param data.model
#' @param filter
#'
#' @return
#' @export
#'
#' @examples


dm_filter_set <- function(data.model, filter){

  # -- Test NULL
  if(!is.null(data.model) & !is.null(filter)){

    # -- Reset filter column & update
    data.model$filter <- FALSE
    data.model[match(filter, data.model$name), ]$filter <- TRUE

  }

  # -- return
  data.model

}
