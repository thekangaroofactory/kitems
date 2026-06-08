

# ------------------------------------------------------------------------------
# This is the kitems Admin Shiny application
# ------------------------------------------------------------------------------

# -- UI
ui <- bslib::page_navbar(title = "Admin Console",
                         window_title = "Kitems Admin Console",
                         id = "nav",
                         bslib::nav_item(
                           id = "darkmode",
                           bslib::input_dark_mode(id = "dark", mode = NULL)),
                         footer = "kitems v0.8.x")


# -- Server
server <- function(input, output, session) {

  # -- get path & check
  path <- Sys.getenv("R_KITEMS_PATH")
  check_path(path)


  # ////////////////////////////////////////////////////////////////////////////
  # Data Migration

  old_dm <- list.files(path = path, pattern = "_data_model.rds", full.names = TRUE, recursive = TRUE)
  if(length(grep(pattern = "backup_", old_dm)))
    old_dm <- old_dm[-grep(pattern = "backup_", old_dm)]

  if(length(old_dm)){

    # -- insert migration UI
    bslib::nav_insert(id = "nav",
                      select = TRUE,
                      nav = bslib::nav_panel(title = "Migration",
                                             icon = icon(name = "person-digging"),
                                             div(id = "migration-required",
                                                 h1(class = "mb-3","Migration required"),
                                                 p("Kitems v0.8.x has introduced a metamodel YAML structure that contains the data model definition.", br(),
                                                   "Old data models (.rds files) need to be migrated."),
                                                 bslib::layout_column_wrap(
                                                   !!!lapply(old_dm, function(x) {

                                                     item_id <- unlist(strsplit(basename(x), split = "_"))[[1]]

                                                     bslib::card(
                                                       bslib::card_header(class = "bg-warning", "Item:", item_id),
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
                                                 actionButton(inputId = "migrate", label = "Start migration", icon = icon(name = "person-digging"))),
                                             div(id = "outcome")))

    # --
    observeEvent(input$migrate, {

      message("Starting data model migration...")

      # -- convert data model(s)
      yaml <- lapply(old_dm, function(x){

        # -- read data model & version
        old_dm <- readRDS(x)
        dm_version <- attr(old_dm, "version")

        # -- backup file
        bakup_dir <- file.path(path, paste0("backup_", gsub(pattern = "\\.", replacement = "_", dm_version)))
        if(!dir.exists(bakup_dir))
          dir.create(bakup_dir)
        file.copy(x, file.path(bakup_dir, basename(x)), copy.date = T)

        new_dm <- dm_migrate(old_dm)

        list(id = unlist(strsplit(basename(x), split = "_"))[[1]],
             source = list(type = "file",
                           path = path),
             data.model = dm_to_yaml(new_dm))})

      # -- save config file
      config_write(yaml, path = path)

      # -- delete old data model files
      file.remove(old_dm)

      removeUI(selector = "#migration-required", immediate = TRUE, multiple = TRUE)
      insertUI(selector = "#outcome",
               where = "beforeEnd",
               ui = tagList(
                 h1("Migration done!"),
                 p(icon("check"), length(old_dm), "data model(s) have been migrated."),

                 bslib::layout_column_wrap(
                   bslib::card(
                     bslib::card_header(class = "bg-success", "Backup"),
                     p("The old data model file(s) can be found in the backup directory:", br(),
                       file.path(path, list.files(path = path, pattern = "backup_")))),

                   bslib::card(
                     bslib::card_header(class = "bg-success", "YAML"),
                     p("The data model(s) are exposed in the YAML configuration file:", br(),
                       file.path(path, "_kitems.yml")))),

                 p(icon("circle-right"), "It's now time to refresh this app to take advantage of the new features!"),
                 actionButton(inputId = "refresh", label = "Refresh page", icon = icon("arrow-rotate-right"))))

    })


    observeEvent(input$refresh, session$reload())

  }


  # ////////////////////////////////////////////////////////////////////////////

  # -- read YAML
  config <- config_read()

  bslib::nav_insert(id = "nav",
                    select = TRUE,
                    nav = bslib::nav_panel(title = "Home",
                                           icon = icon(name = "home"),

                                           if(is.null(config))
                                             p("There is no item available in this project.")

                                           else
                                             bslib::layout_sidebar(
                                               border = FALSE,

                                               sidebar = bslib::sidebar(
                                                 position = "right",
                                                 width = 300,
                                                 open = TRUE,

                                                 # -- yaml
                                                 h3(icon("gears"), "YAML"),
                                                 file.path(path, "_kitems.yml")

                                               ),

                                               h1(class = "mb-3", ktools::toupper_words(basename(path))),

                                               bslib::layout_column_wrap(

                                                 bslib::card(
                                                   bslib::card_header(length(config), "Item(s)"),
                                                   tags$ul(lapply(sapply(config, "[[", "id"), tags$li))),

                                                 actionButton(inputId = "add", label = "+"),
                                                 actionButton(inputId = "import", label = "Import")

                                                 ))
                    ))


  # ////////////////////////////////////////////////////////////////////////////
  # Items Management



  # -- add one tab per item
  if(!is.null(config)){

    # -- get list of items
    #items_list <- sapply(config, "[[", "id")

    lapply(config, function(x) {

      bslib::nav_insert(id = "nav",
                        nav = bslib::nav_panel(title = x$id,
                                               icon = icon(name = "box"),

                                               bslib::layout_sidebar(
                                                 border = FALSE,

                                                 sidebar = bslib::sidebar(
                                                   position = "right",
                                                   width = 300,
                                                   open = TRUE,

                                                   h3("Source"),
                                                   p("Type:", x$source$type, br(),
                                                     if(x$source$type == "file")
                                                       paste("path:", x$source$path)),

                                                   h3("Skipped"),
                                                   p("No input will be generated for those attributes when creating / updating items."),
                                                   span(class = "text-warning", paste(x$data.model$skip, collapse = "|")),

                                                   h3("Display"),
                                                   p("Attributes that won't be displayed in the item table."),
                                                   span(class = "text-warning", paste(x$data.model$hide, collapse = "|")),

                                                   h3("Danger zone"),
                                                   bslib::input_switch(id = "dz", label = "Allow")

                                                   ),

                                                 h1(class = "mb-3", length(x$data.model$attributes), "attributes"),
                                                 bslib::layout_column_wrap(
                                                   !!!lapply(x$data.model$attributes, card_attribute),
                                                   actionButton(inputId = "create", "+"))


                                               )




                                               ))

    })


  }




  showModal(
    modalDialog(

      bslib::layout_columns(
        col_widths = c(2,10),

        tagList(
          p("Step 1"),
          p("Step 2")),

        "Main content"

      )


    )
  )





  # ////////////////////////////////////////////////////////////////////////////
  # -- check YAML file


  # items <- character()
  #
  # # -- check items
  # output$admin_console <- if(length(items) == 0)
  #
  #   # -- ui: display message
  #   renderUI(
  #     column(width = 12,
  #            h3("Kitems Admin Console"),
  #            p(id = "subtitle", em("Manage your items data model")),
  #            wellPanel("No item has been found in the provided path.")))
  #
  # else {
  #
  #   # -- launch item servers
  #   res <- lapply(items, function(x) kitems::kitems(id = x, options = list(admin = TRUE)))
  #
  #   # -- ui
  #   renderUI({
  #
  #     # -- build tabPanels content
  #     panels <- lapply(items, function(x) tabPanel(x, kitems::admin_widget(x)))
  #
  #     # -- build page & return
  #     do.call(navbarPage, c(panels,
  #                           id = "page",
  #                           title = "Kitems"))})
  #
  #
  # } # check items

}


# -- Run the application
shinyApp(ui = ui, server = server)
