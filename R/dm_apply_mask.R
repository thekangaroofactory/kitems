

#' Title
#'
#' @param data.model
#' @param items
#'
#' @return
#' @export
#'
#' @examples


dm_apply_mask <- function(data.model, items){

  # -- Get filter from data model
  filter_cols <- dm_filter(data.model)

  # -- Apply filter
  value <- if(is.null(filter_cols)){

    items

  } else {

    items[-which(names(items) %in% filter_cols)]

  }

}
