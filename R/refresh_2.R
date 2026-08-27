

refresh <- function(config, item, ...){
  config_attribute_behavior(config, item, behavior = "refresh", ...)}

#' @rdname refresh
#' @export
freeze <- function(config, item, ...){
  config_attribute_behavior(config, item, behavior = "refresh", ..., set = FALSE)}

#' @rdname refresh
#' @export
refreshed <- function(config, item){
  config_item_behavior(config, item, behavior = "refresh")}

#' @rdname refresh
#' @export
frozen <- function(config, item){
  config_item_behavior(config, item)[!config_item_behavior(config, item) %in% config_item_behavior(config, item, behavior = "refresh")]}
