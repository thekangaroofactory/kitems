

#' Apply mask
#'
#' @param data.model a data.frame of the data model
#' @param items a data.frame of the items
#'
#' @return a data.frame of the items with applied masks
#' @export
#'
#' @details
#' Two masks are applied:
#' - the data model masks (filter = TRUE)
#' - a default mask (replace . and _ by a space in the attribute names, plus capitalize first letter)
#'
#' @examples
#' \dontrun{
#' item_mask(data.model = "mydatamodel", items = "myitems")
#' }

item_mask <- function(data.model, items){

  # -- Get filter from data model
  filter_cols <- dm_filter(data.model)

  # -- Apply attribute filter
  if(!is.null(filter_cols))
    items <- items[-which(names(items) %in% filter_cols)]


  # -- Apply attribute/column name mask
  if(!is.null(items)){
    colnames(items) <- gsub(".", " ", colnames(items), fixed = TRUE)
    colnames(items) <- gsub("_", " ", colnames(items), fixed = TRUE)
    colnames(items) <- stringr::str_to_title(colnames(items))}

  # -- return
  items

}
