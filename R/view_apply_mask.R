

#' Title
#'
#' @param data
#'
#' @return
#' @export
#'
#' @examples


view_apply_mask <- function(data){

  # -- Apply attribute/column name mask
  colnames(data) <- gsub(".", " ", colnames(data), fixed = TRUE)
  colnames(data) <- gsub("_", " ", colnames(data), fixed = TRUE)
  colnames(data) <- stringr::str_to_title(colnames(data))

  # -- return
  data

}
