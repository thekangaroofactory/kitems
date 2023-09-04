

#' Title
#'
#' @param colClasses a named vector of classes, defining the data model
#' @param default.val a named vector of values, defining the default values
#' @param default.fun a name vector of functions, defining the default functions to be used to generate default values
#'
#' @return a data.frame containing the data model
#'
#' @examples data_model(colClasses, default.val, default.fun)


data_model <- function(colClasses, default.val, default.fun){

  # -- build data.frame from colClasses (named vector)
  dm <- data.frame("type" = colClasses)

  # -- add default.val (reorder input)
  default.val <- default.val[order(row.names(dm))]
  dm$default.val <- default.val

  # -- add default.fun (reorder input)
  default.fun <- default.fun[order(row.names(dm))]
  dm$default.fun <- default.fun

  # -- return
  dm

}


