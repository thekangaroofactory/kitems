

#' Title
#'
#' @param items
#' @param resource works with either default.val / default.fun / filter_cols
#'
#' @return
#' @export
#'
#' @examples


check_resource <- function(items, resource){

  # -- get items data.frame column names
  column_names <- colnames(items)

  # -- check resource_val (all names must be in df cols)
  if(!is.null(resource))
    if(!all(names(resource) %in% column_names)){

      cat("- fixing resource values! \n")

      # -- fix: keep only names in item df!
      resource <- resource[names(resource) %in% column_names]

      # -- check if empty
      if(identical(resource, character(0)))
        resource <- NULL

    }

  # -- return
  resource

}
