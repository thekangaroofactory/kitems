

#' Data Model Mask
#'
#' @description
#' Apply mask on the data model.
#'
#' @param data.model a data.frame of the data model.
#'
#' @return A data.frame with renamed columns.
#' @export
#'
#' @examples
#' \dontrun{
#' dm_mask(data.model = dm)
#' }

dm_mask <- function(data.model){

  # -- Apply attribute/column name mask
  if(!is.null(data.model)){
    colnames(data.model) <- gsub(".", " ", colnames(data.model), fixed = TRUE)
    colnames(data.model) <- gsub("_", " ", colnames(data.model), fixed = TRUE)
    colnames(data.model) <- gsub("val", "value", colnames(data.model), fixed = TRUE)
    colnames(data.model) <- gsub("fun", "function", colnames(data.model), fixed = TRUE)
    colnames(data.model) <- stringr::str_to_title(colnames(data.model))}

  # -- return
  data.model

}
