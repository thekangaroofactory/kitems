

#' Apply Mask
#'
#' @description
#' Apply mask on names.
#'
#' @param x a data.frame or named object
#'
#' @return A renamed data.frame or object.
#' @export
#'
#' @examples
#' \dontrun{
#' mask(x = dm)
#' }

mask <- function(x){

  # -- check input
  if(is.null(names(x)))
    return(x)

  # -- Apply attribute/column name masks
  names(x) <- gsub(".", " ", names(x), fixed = TRUE)
  names(x) <- gsub("-", " ", names(x), fixed = TRUE)
  names(x) <- gsub("_", " ", names(x), fixed = TRUE)
  names(x) <- stringr::str_to_title(names(x))

  # -- return
  x

}
