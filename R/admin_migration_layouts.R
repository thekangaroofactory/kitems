

# //////////////////////////////////////////////////////////////////////////////
#' Migration Required Layout
#'
#' @param files a list of data.model files to migrate
#'
#' @returns a layout
#'
#' @examples
#' \dontrun{
#' admin_migration_required_layout("./item_data_model.rds")
#' }

admin_migration_required_layout <- function(files){

  # -- return
  div(id = "migration-required",

      h1(class = "mb-3","Migration required"),
      p("Kitems v0.8.x has introduced a metamodel YAML structure that contains the data model definition.", br(),
        "Old data models (.rds files) need to be migrated."),

      # -- wrapper
      bslib::layout_column_wrap(
        !!!lapply(files, function(x) {

          # -- return
          bslib::card(
            bslib::card_header(class = "bg-warning", "Item:", unlist(strsplit(basename(x), split = "_"))[[1]]),
            bslib::layout_column_wrap(
              heights_equal = "row",
              tagList("Data model file:", br(), x),
              tagList(
                "Actions that will be applied during migration:", br(),
                tags$ul(
                  tags$li("Backup file"),
                  tags$li("Upgrade data model"),
                  tags$li("Convert to YAML")))))})),

      p("Once migrated, data model(s) will be merged into a single YAML configuration file."),
      actionButton(inputId = "migrate", label = "Start migration", icon = icon(name = "person-digging")))

}


# //////////////////////////////////////////////////////////////////////////////
#' Migration Done Layout
#'
#' @param path the path of the project
#'
#' @returns an HTML layout
#'
#' @examples
#' \dontrun{
#' admin_migration_done_layout(path = ".")
#' }

admin_migration_done_layout <- function(path){

  backups <- list.files(list.files(path = Sys.getenv("R_KITEMS_PATH"), pattern = "backup_", full.names = T))
  config_file <- name(what = "config", file = T)

  # -- return
  div(

    h1("Migration done!"),
    p(icon("check"), length(backups), "data model(s) have been migrated."),

    bslib::layout_column_wrap(
      bslib::card(
        bslib::card_header(class = "bg-success", "Backup"),
        p("The old data model file(s) can be found in the backup directory:", br(),
          paste(backups, collapse = "|"))),

      bslib::card(
        bslib::card_header(class = "bg-success", "YAML"),
        p("The data model(s) are exposed in the YAML configuration file:", br(),
          config_file))),

    p(icon("circle-right"), "It's now time to refresh this app to take advantage of the new features!"),
    actionButton(inputId = "refresh", label = "Refresh page", icon = icon("arrow-rotate-right")))

}
