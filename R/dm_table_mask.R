

#' Apply mask on data model table
#'
#' @param data.model a data.frame of the data model
#'
#' @return a data.frame with renamed columns
#' @export
#'
#' @examples
#' \dontrun{
#' dm_table_mask(data.model = dm)
#' }


dm_table_mask <- function(data.model){

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
