

#' Apply data model filter
#'
#' @param data.model a \emph{mandatory} data model
#' @param items a \emph{mandatory} item data.frame
#'
#' @return an item data.frame, without the filtered attributes (columns)
#' @export
#'
#' @examples
#' \dontrun{
#' filetered_items <- dm_apply_mask(data.model = mydatamodel, items = myitems)
#' }


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
