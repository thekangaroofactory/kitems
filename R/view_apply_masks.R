

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
#' view_apply_masks(data.model = "mydatamodel", items = "myitems")
#' }

view_apply_masks <- function(data.model, items){

  # -- Apply data model masks
  items <- dm_apply_mask(data.model, items)

  # -- Apply attribute/column name mask
  if(!is.null(items)){
    colnames(items) <- gsub(".", " ", colnames(items), fixed = TRUE)
    colnames(items) <- gsub("_", " ", colnames(items), fixed = TRUE)
    colnames(items) <- stringr::str_to_title(colnames(items))}

  # -- return
  items

}
