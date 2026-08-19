

# ------------------------------------------------------------------------------
# This is the kitems Admin Console application
# ------------------------------------------------------------------------------

# -- UI
# The main layout will be used to dynamically insert / remove content from
# the server side.

ui <- bslib::page_navbar(title = "Admin Console",
                         window_title = "Kitems Admin Console",
                         id = "nav",

                         shinyjs::useShinyjs(),

                         # -- home tab (persistent)
                         bslib::nav_panel(title = "Home",
                                          value = "home",
                                          icon = icon(name = "home"),

                                          # -- layout
                                          bslib::layout_sidebar(
                                            border = FALSE,

                                            # -- sidebar
                                            sidebar = bslib::sidebar(
                                              id = "home-sidebar",
                                              position = "right",
                                              width = 300,
                                              open = FALSE,

                                              # -- yaml
                                              h3("YAML", icon("gears")),
                                              textOutput("yaml_file"),
                                              uiOutput("yaml_message")),

                                            # -- main
                                            # container where to insert elements
                                            h1(class = "mb-3", textOutput("project_name")),

                                            # -- wrapper
                                            div(id = "home-project-items-section",
                                                bslib::layout_column_wrap(
                                                  id = "home-project-items",
                                                  bslib::card(id = "home-items-create",
                                                      p(actionLink(inputId = "item_create", label = "Add"), "an item to the project.")))))),

                         # -- space
                         # To ensure dark mode switch is on right
                         bslib::nav_spacer(),

                         # -- link to package documentation
                         bslib::nav_item(
                           a(href="https://thekangaroofactory.github.io/kitems/", "kitems", target = "_blank")),

                         # -- dark mode switch
                         bslib::nav_item(
                           bslib::input_dark_mode(id = "dark", mode = NULL)),

                         footer = paste0("kitems v", as.character(packageVersion("kitems"))))


# -- Server
server <- function(input, output, session) {

  # ////////////////////////////////////////////////////////////////////////////
  # -- check path & config file

  # -- get path & check
  path <- Sys.getenv("R_KITEMS_PATH")
  tryCatch(check_path(path),
           error = function(e) {
             showModal(modalDialog(e$message,
                                   title = "Environment error",
                                   size = "l",
                                   footer = NULL))
             stop(e$message)})


  # ////////////////////////////////////////////////////////////////////////////
  # Data Migration
  # Check first if data migration is required as it will generate a YAML file.

  legacy_dm <- list.files(path = path, pattern = "_data_model.rds", full.names = TRUE, recursive = TRUE)
  if(length(grep(pattern = "backup_", legacy_dm)))
    legacy_dm <- legacy_dm[-grep(pattern = "backup_", legacy_dm)]

  if(length(legacy_dm)){

    # -- insert migration tab
    bslib::nav_insert(id = "nav",
                      target = "home",
                      position = "after",
                      select = TRUE,

                      nav = bslib::nav_panel(title = "Migration",
                                             icon = icon(name = "person-digging"),

                                             # -- main container
                                             # where to dynamically add / remove content
                                             div(id = "migration-content")))

    # -- remove home
    # after cause we need it to insert after..
    bslib::nav_remove(id = "nav", target = "home")

    # -- add content (to migrate)
    insertUI(selector = "#migration-content",
             where = "afterBegin",
             admin_migration_required_layout(files = legacy_dm))

    # -- create migration listener (button)
    observeEvent(input$migrate, {

      message("Starting data model migration...")

      # -- convert data model(s)
      config <- lapply(legacy_dm, function(x){

        # -- read data model & version
        legacy_dm <- readRDS(x)
        dm_version <- attr(legacy_dm, "version")

        # -- backup file
        bakup_dir <- file.path(path, paste0("backup_", gsub(pattern = "\\.", replacement = "_", dm_version)))
        if(!dir.exists(bakup_dir))
          dir.create(bakup_dir)
        file.copy(x, file.path(bakup_dir, basename(x)), copy.date = T)

        # -- do migration & return yaml
        new_dm <- dm_migrate(legacy_dm)
        c(config_item(id = unlist(strsplit(basename(x), split = "_"))[[1]], path = path),
          data.model = dm_to_yaml(new_dm))

      })

      # -- save config file
      config_write(c(config_create(basename(path)), items = list(config)), path = path)

      # -- delete old data model files
      file.remove(legacy_dm)

      # -- update layout
      removeUI(selector = "#migration-required", immediate = TRUE, multiple = TRUE)
      insertUI(selector = "#migration-content",
               where = "afterBegin",
               ui = admin_migration_done_layout(path))

      # -- refresh page listener (button)
      observeEvent(input$refresh, session$reload())

    }, once = TRUE)

  }


  # ////////////////////////////////////////////////////////////////////////////
  # YAML configuration

  # -- read YAML
  config_file <- file.path(path, "_kitems.yml")
  yaml <- config_read(path)
  config <- reactiveVal(yaml)

  # -- reactive objects
  item_list <- reactive(sapply(config()$items, "[[", "id"))

  # -- when YAML is missing
  # config_read will return NULL
  if(is.null(yaml) && !length(legacy_dm)){

    # -- dialog
    showModal(
      modalDialog(
        size = "xl",
        admin_no_yaml_layout(),
        footer = actionButton(inputId = "close_app", label = "Close app")))

    # -- dismiss (then force close app)
    observeEvent(input$close_app, stopApp())

    # -- create listener
    # only when no config is found + self-destroy
    observeEvent(input$yaml_create, {

      removeModal()

      # -- create config file & store
      config(config_create(project = basename(path)))

      # -- update ui
      bslib::toggle_sidebar(id = "home-sidebar", open = TRUE)

    }, once = TRUE)

  } else bslib::toggle_sidebar(id = "home-sidebar", open = TRUE)

  # -- auto save
  observeEvent(config(), config_write(config()), ignoreInit = T)


  # ////////////////////////////////////////////////////////////////////////////
  # Navigation

  # -- Select tab
  observeEvent(input$select_tab, {

    # -- get id from input value
    tab_id <- unlist(strsplit(input$select_tab, "_"))[1]

    # -- select
    bslib::nav_select(id = "nav", selected = tab_id)

  })


  # ////////////////////////////////////////////////////////////////////////////
  # Home tab

  # -- outputs (sidebar)
  output$yaml_file <- renderText(if(!is.null(config())) config_file else "")
  output$yaml_message <- renderUI(admin_yaml_message(config()))

  # -- outputs (main)
  output$project_name <- renderText(ktools::toupperfirst(config()$project))


  # ////////////////////////////////////////////////////////////////////////////
  # create item

  # -- create (actionLink)
  observeEvent(input$item_create, {

    # -- dialog
    showModal(
      modalDialog(
        title = "Add item",
        textInput(inputId = "add_item_name",
                  label = "Item name"),
        uiOutput("add_item_message"),
        textInput(inputId = "add_item_description",
                  label = "Description"),
        footer =  tagList(
          modalButton("Cancel"),
          actionButton(inputId = "item_create_confirm",
                       label = "Create"))))

  })


  # -- watch dialog input
  output$add_item_message <- renderUI({

    req(input$add_item_name != "")

    if(grepl('[^[:alnum:]]', input$add_item_name))
      span(class = "text-danger", icon("circle-chevron-right"), "This name is not valid.")
    else if(input$add_item_name %in% item_list())
      span(class = "text-warning", icon("circle-chevron-right"), "This name already exist!")
    else
      span(class = "text-success-emphasis", icon("circle-chevron-right"), "This name is valid.")

  })


  # -- confirm dialog
  observeEvent(input$item_create_confirm, {

    # -- secure
    req(input$add_item_name != "",
        !input$add_item_name %in% item_list(),
        !grepl('[^[:alnum:]]', input$add_item_name))

    # -- close dialog
    removeModal()

    # -- get config & last tab id
    yaml <- config()
    last_tab <- tail(item_list(), n = 1L)
    if(length(last_tab) == 0) last_tab <- "home"

    # -- update config & store
    new_item <- config_item(id = input$add_item_name,
                            description = input$add_item_description,
                            path = path)
    yaml$items <- c(yaml$items, list(new_item))
    config(yaml)

    # -- ui: add item card
    insertUI(selector = "#home-project-items > div:last",
             where = "beforeBegin",
             admin_item_card(name = input$add_item_name, description = input$add_item_description))

    # -- ui: add item tab
    bslib::nav_insert(id = "nav",
                      target = last_tab,
                      position = "after",
                      nav = admin_item_layout(new_item))

  })


  # ////////////////////////////////////////////////////////////////////////////
  # Items Management

  # -- add one tab per item
  if(!is.null(yaml$items)){

    lapply(rev(yaml$items), function(x) {

      # -- update nav
      bslib::nav_insert(id = "nav",
                        target = "home",
                        position = "after",
                        nav = admin_item_layout(x))

      # -- update item list
      insertUI(selector = "#home-project-items",
               where = "afterBegin",
               admin_item_card(name = x$id,
                               description = x$description))})}

  # -- update description
  observeEvent(input$update_description, {

     # -- get item
    item <- unlist(strsplit(input$update_description, "_"))[1]

    # -- dialog
    showModal(
      modalDialog(
        title = item,
        textInput(inputId = "update_item_description",
                  label = "Description"),
        footer = tagList(
          modalButton(label = "Cancel"),
          actionButton(inputId = "item_upd_desc_confirm", label = "Update"))))

    # -- confirm dialog
    observeEvent(input$item_upd_desc_confirm, {

      removeModal()

      # -- update yaml
      yaml <- config()
      yaml$items[[match(item, item_list())]]$description <- input$update_item_description
      config(yaml)

      # -- update ui
      js <- paste0("$('#", item, "_description').html('", input$update_item_description, "')")
      shinyjs::runjs(js)

    }, ignoreInit = T, once = T)

  })

}


# -- Run the application
shinyApp(ui = ui, server = server)
