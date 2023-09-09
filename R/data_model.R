

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

  cat("[data_model] Update data model \n")

  # -- build data.frame from colClasses (named vector)
  dm <- data.frame("type" = colClasses)

  # -- add default.val (reorder input)
  dm$default.val <- default.val[match(row.names(dm), names(default.val))]

  # -- add default.fun (reorder input)
  dm$default.fun <- default.fun[match(row.names(dm), names(default.fun))]

  # -- return
  dm

}


