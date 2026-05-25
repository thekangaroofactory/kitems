

#' Save Items
#'
#' @description
#' Saves the items data.frame.
#'
#' @param data a data.frame containing the data to be saved.
#' @param connector a list parameters that will passed to iker::save_data() call.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # -- File connector:
#' item_save(data = mydata, connector = list(type = "file", file = "path/to/my/data/mydata.csv")
#' }

item_save <- function(data, connector){

  iker::save_data(data, path = NULL, file = connector$file)

}
