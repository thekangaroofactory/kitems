

#' Title
#'
#' @param data.model
#' @param items
#'
#' @return
#' @export
#'
#' @examples

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
