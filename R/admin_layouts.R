

admin_no_yaml_layout <- function(){

  div(id = "home-no-yaml",
      h1("Welcome"),
      h2("There is no YAML configuration available for this project."),
      p("Click", actionLink(inputId = "yaml_create", label = "here"), "to create one."))

}


admin_yaml_message <- function(config){

  if(is.null(config))
    return(p(class = "text-warning", icon("circle-chevron-right"), "The project has no config file!"))

  if(is.null(config$items))
    return(p(class = "text-warning", icon("circle-chevron-right"), "The project has no item yet."))

  if(!is.null(config$version))
    return(p(class = "text-success-emphasis", icon("circle-chevron-right"), "Version:", config$version))

}
