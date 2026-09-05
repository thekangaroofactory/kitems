

# ------------------------------------------------------------------------------
# This is the kitems Admin Console application
# ------------------------------------------------------------------------------

# -- UI
# The main layout will be used to dynamically insert / remove content from
# the server side.

ui <- bslib::page_navbar(title = "Admin Console",
                         window_title = "Kitems Admin Console",
                         id = "nav",
                         fillable = FALSE,

                         # -- allow shinyjs
                         header = shinyjs::useShinyjs(),

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
                                                              p(actionLink(inputId = "item_create", label = "Add"), "an item group to the project.")))))),

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
      items_list <- lapply(legacy_dm, function(x){

        # -- read data model & version
        dm <- readRDS(x)
        dm_version <- attr(dm, "version")

        # -- backup file
        bakup_dir <- file.path(path, paste0("backup_", gsub(pattern = "\\.", replacement = "_", dm_version)))
        if(!dir.exists(bakup_dir))
          dir.create(bakup_dir)
        file.copy(x, file.path(bakup_dir, basename(x)), copy.date = T)

        # -- do migration & return yaml
        new_dm <- dm_migrate(dm)
        x <- ci_create(id = unlist(strsplit(basename(x), split = "_"))[[1]], path = path)
        x$data.model <- dm_to_yaml(new_dm)

        # return
        x

      })

      # -- merge & save config
      config_write(
        do.call(ci_append,
                c(list(config = c_create(project = basename(path))),
                  items_list)))

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
  yaml_init <- config_read(path)
  config <- reactiveVal(yaml_init)

  # -- reactive objects
  item_list <- reactive(sapply(config()$items, "[[", "id"))

  # -- when YAML is missing
  # config_read will return NULL
  if(is.null(yaml_init) && !length(legacy_dm)){

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
      config(c_create(project = basename(path)))

      # -- update ui
      bslib::toggle_sidebar(id = "home-sidebar", open = TRUE)

    }, once = TRUE)

  } else bslib::toggle_sidebar(id = "home-sidebar", open = TRUE)

  # -- auto save
  observeEvent(config(), config_write(config()), ignoreInit = T)


  # ////////////////////////////////////////////////////////////////////////////
  # Init item tabs

  # -- add one tab per item
  if(!is.null(yaml_init$items)){

    lapply(rev(yaml_init$items), function(x) {

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

  # -- drop yaml_init
  # to secure against use of the static object
  rm(yaml_init)


  # ////////////////////////////////////////////////////////////////////////////
  # Items Selective Loading

  # -- init datamart
  # use items() to get / load items
  datamart <- reactiveValues()


  # ////////////////////////////////////////////////////////////////////////////
  # Home tab

  # -- outputs (sidebar)
  output$yaml_file <- renderText(if(!is.null(config())) name("_kitems.yml", url = T) else "")
  output$yaml_message <- renderUI(admin_yaml_message(config()))

  # -- outputs (main)
  output$project_name <- renderText(ktools::toupperfirst(config()$project))


  # ////////////////////////////////////////////////////////////////////////////
  # Navigation

  # -- Select tab
  observeEvent(input$select_tab, {

    # -- get id from input value
    event <- ktools::input_decode(input$select_tab)
    tab_id <- event[['namespace']]

    # -- select
    bslib::nav_select(id = "nav", selected = tab_id)

  })


  # ////////////////////////////////////////////////////////////////////////////
  # create item

  # -- create (actionLink)
  observeEvent(input$item_create, {

    # -- dialog
    showModal(
      modalDialog(
        title = "Add item",
        textInput(inputId = "item_name",
                  label = "Item name"),
        div(id = "item-name-message"),
        textInput(inputId = "item_description",
                  label = "Description"),
        footer = tagList(
          modalButton("Cancel"),
          actionButton(inputId = "item_create_confirm",
                       label = "Create"))))

  })


  # -- watch dialog input
  observeEvent(input$item_name, {

    shinyjs::html(id = "item-name-message",
                  html = if(input$item_name == "")
                    ""
                  else if(grepl('[^[:alnum:]]', input$item_name))
                    paste(span(class = "text-danger", icon("circle-chevron-right"), "This name is not valid."))
                  else if(input$item_name %in% item_list())
                    paste(span(class = "text-warning", icon("circle-chevron-right"), "This name already exist!"))
                  else
                    paste(span(class = "text-success-emphasis", icon("circle-chevron-right"), "This name is valid.")))

  })


  # -- confirm dialog
  observeEvent(input$item_create_confirm, {

    # -- secure
    req(input$item_name != "",
        !input$item_name %in% item_list(),
        !grepl('[^[:alnum:]]', input$item_name))

    # -- close dialog
    removeModal()

    # -- last tab id
    last_tab <- utils::tail(item_list(), n = 1L)
    if(length(last_tab) == 0) last_tab <- "home"

    # -- update config & store
    config(
      config() |>
        ci_append(
          ci_create(id = input$item_name,
                    description = input$item_description,
                    path = path)))

    # -- ui: add item card
    insertUI(selector = "#home-project-items > div:last",
             where = "beforeBegin",
             admin_item_card(name = input$item_name, description = input$item_description))

    # -- ui: add item tab
    bslib::nav_insert(id = "nav",
                      target = last_tab,
                      position = "after",
                      nav = admin_item_layout(c_extract(config(), input$item_name)))

  })


  # ////////////////////////////////////////////////////////////////////////////
  # Danger zone(s)

  # -- extract 'dz' switch inputs & init cache
  # logical named vector
  dz_switch <- reactive(sapply(names(input)[grepl("dz", names(input))], function(x) input[[x]]))
  dz_switch_cache <- reactiveVal()

  # -- hide / show
  observeEvent(dz_switch(), {

    # -- check
    # actual & cache vectors must be same length (otherwise we're just adding a switch)
    if(length(dz_switch()) == length(dz_switch_cache())){

      # -- get updated switch (clicked)
      upd_switch <- dz_switch()[dz_switch() != dz_switch_cache()]

      # -- insert / remove UI
      if(length(upd_switch)){
        id <- names(upd_switch)
        if(upd_switch)
          insertUI(selector = paste0("#", id, "_container"),
                   where = "afterEnd",
                   div(id = paste0(id, "_content"),
                       admin_item_dz(name = unlist(strsplit(id, split = "_"))[[1]])))
        else
          removeUI(selector = paste0("#", id, "_content"), immediate = TRUE)}}

    # -- update cache
    dz_switch_cache(dz_switch())

  })


  # -- delete item
  observeEvent(input$item_delete, {

    # -- decode input
    event <- ktools::input_decode(input$item_delete)
    id <- event[['namespace']]

    showModal(
      modalDialog(
        p(class = "text-danger", "This action cannot be undone!", br(),
          "Data model & items will be lost."),
        p("Are you sure you want to delete", id, "item group?", br(),
          "Type:", paste0("delete-", id), "to confirm."),
        textInput(inputId = "item_delete_string", label = ""),
        title = "Delete item group!",
        size = "l",
        footer = tagList(
          modalButton(label = "Cancel"),
          actionButton(inputId = "item_delete_confirm",
                       label = "Confirm delete"))))

  })


  # -- confirm delete item
  observeEvent(input$item_delete_confirm, {

    # -- extract target item & check
    id <- unlist(strsplit(input$item_delete, split = "_"))[[1]]
    req(input$item_delete_string == paste0("delete-", id))

    removeModal()

    # -- update config & store
    config(config() |>
             ci_drop(item = id))

    # -- delete item file
    warning("Item file & folder should be deleted here!")

    # -- ui: drop item card & tab + notify
    removeUI(selector = paste0("#", id, "-item-card"), immediate = TRUE)
    bslib::nav_remove(id = "nav", target = id)
    bslib::nav_select(id = "nav", selected = "home")
    showNotification(paste("Item", id, "has been deleted."))

  })


  # ////////////////////////////////////////////////////////////////////////////
  # Items Management

  # -- update description
  observeEvent(input$item_update_description, {

    # -- get item
    event <- ktools::input_decode(input$item_update_description)
    item <- event['namespace']

    # -- dialog
    showModal(
      modalDialog(
        title = item,
        textInput(inputId = "item_update_description_value",
                  label = "Description"),
        footer = tagList(
          modalButton(label = "Cancel"),
          actionButton(inputId = "item_update_description_confirm", label = "Update"))))

    # -- confirm dialog
    observeEvent(input$item_update_description_confirm, {

      removeModal()

      # -- update yaml
      yaml <- config()
      yaml$items[[match(item, item_list())]]$description <- input$item_update_description_value
      config(yaml)

      # -- update ui
      # update description
      shinyjs::html(id = paste0(item, "-description"),
                    html = paste("Description:", input$item_update_description_value))

    }, ignoreInit = T, once = T)

  })


  # ////////////////////////////////////////////////////////////////////////////
  # Attribute Management

  # -- centralized action manager
  observeEvent(input$attribute_action, {

    # -- extract event & get yaml
    event <- ktools::input_decode(input$attribute_action)
    ktools::catl("Attribute event received:", paste(names(event), event, sep = " = ", collapse = ", "))
    yaml <- config()

    # -- perform action
    if(event['action'] == "attribute_create"){

      # ------------------------------------------------------------------------
      # Create attribute

      callback <- reactiveVal()
      admin_attribute_wizard(yaml, item = event['namespace'], callback = callback)

      # -- listen to callback
      observeEvent(callback(), {

        # -- update config
        yaml <- yaml |>
          ca_append(item = event['namespace'],
                    attribute = ca_create(
                      name = callback()$name,
                      description = callback()$description,
                      type = callback()$type,
                      class.arg = if(callback()$class.arg == "") NULL else callback()$class.arg,
                      values = if(callback()$values == "") NULL else callback()$values,
                      default = if(callback()$default == "") NULL else callback()$default))

        if(callback()$skip)
          yaml <- yaml |>
            ca_behavior(item = event['namespace'],
                        behavior = "skip", callback()$name)

        if(callback()$refresh && callback()$skip)
          yaml <- yaml |>
            ca_behavior(item = event['namespace'],
                        behavior = "refresh", callback()$name)

        if(callback()$hide)
          yaml <- yaml |>
            ca_behavior(item = event['namespace'],
                        behavior = "hide", callback()$name)

        # -- store the new config
        config(yaml)

        # -- update UI
        # add attribute card
        item <- c_extract(yaml, item = event['namespace'])
        at <- c_extract(yaml, item = event['namespace'], attribute = callback()$name)
        insertUI(selector = paste0("#", event['namespace'], "-attributes > div:last"),
                 where = "beforeBegin",
                 div(class="bslib-grid-item bslib-gap-spacing html-fill-container",
                     admin_attribute_card(attribute = at,
                                          item = event['namespace'],
                                          hide = item$data.model$hide,
                                          skip = item$data.model$skip,
                                          refresh = item$data.model$refresh)))

        # update attribute nb
        shinyjs::html(id = paste0(event['namespace'], "-attribute-nb"),
                      html = admin_attribute_nb(item))
        # update skipped, refreshed & hidden (sidebar)
        shinyjs::html(id = paste0(event['namespace'], "-skipped-attributes"),
                      html = paste(item$data.model$skip, collapse = "|"))
        shinyjs::html(id = paste0(event['namespace'], "-refreshed-attributes"),
                      html = paste(item$data.model$refresh, collapse = "|"))
        shinyjs::html(id = paste0(event['namespace'], "-hidden-attributes"),
                      html = paste(item$data.model$hide, collapse = "|"))

        # -- cleanup
        callback(NULL)

      }, once = TRUE)


    } else if(event['action'] == "attribute_update"){

      # ------------------------------------------------------------------------
      # Update attribute

      callback <- reactiveVal()
      admin_attribute_wizard(yaml,
                             item = event['namespace'],
                             attribute = event['value'],
                             callback)

      # -- listen to callback
      observeEvent(callback(), {

        # -- update attribute
        yaml <- yaml |>
          ca_replace(item = event['namespace'],
                     attribute = ca_create(name = callback()$name,
                                           description = callback()$description,
                                           type = callback()$type,
                                           class.arg = if(callback()$class.arg == "") NULL else callback()$class.arg,
                                           values = if(callback()$values == "") NULL else callback()$values,
                                           default = if(callback()$default == "") NULL else callback()$default))

        # -- update behaviors
        yaml <- yaml |>
          ca_behavior(item = event['namespace'], behavior = "skip", callback()$name, set = callback()$skip) |>
          ca_behavior(item = event['namespace'], behavior = "refresh", callback()$name, set = callback()$refresh && callback()$skip) |>
          ca_behavior(item = event['namespace'], behavior = "hide", callback()$name, set = callback()$hide)

        # -- store config
        config(yaml)

        # -- update UI
        # replace attribute card
        dm <- c_extract(yaml, item = event['namespace'])$data.model
        at <- c_extract(yaml, item = event['namespace'], attribute = callback()$name)
        # remove old card
        removeUI(selector = paste0("#", paste(event['namespace'], event['value'],
                                              "attribute-card", sep = "-")),
                 immediate = TRUE)
        # insert updated card
        insertUI(selector = paste0("#", paste(event['namespace'], event['value'],
                                              "attribute-card-container", sep = "-")),
                 where = "afterBegin",
                 immediate = TRUE,
                 admin_attribute_card(attribute = at,
                                      item = event['namespace'],
                                      hide = dm$hide,
                                      skip = dm$skip,
                                      refresh = dm$refresh))

        # update skipped, refreshed & hidden (sidebar)
        shinyjs::html(id = paste0(event['namespace'], "-skipped-attributes"),
                      html = paste(dm$skip, collapse = "|"))
        shinyjs::html(id = paste0(event['namespace'], "-refreshed-attributes"),
                      html = paste(dm$refresh, collapse = "|"))
        shinyjs::html(id = paste0(event['namespace'], "-hidden-attributes"),
                      html = paste(dm$hide, collapse = "|"))

        # -- cleanup
        callback(NULL)

      }, once = TRUE)



    } else if(event['action'] == "attribute_move"){

      # ------------------------------------------------------------------------
      # Move attribute

      choices <- c_attributes(yaml, item = event['namespace'])
      choices <- choices[!choices %in% event['value']]

      # -- dialog
      showModal(
        modalDialog(
          title = "Move Attribute",
          p("Move attribute", event['value'], "column:"),
          radioButtons(inputId = "attribute_move_position", label = "Position", choices = list("before", "after")),
          selectInput(inputId = "attribute_move_target",
                      label = "Attribute",
                      choices = choices),
          footer = tagList(modalButton(label = "Cancel"),
                           actionButton(inputId = "attribute_move_confirm", label = "Move"))))

      # -- action
      observeEvent(input$attribute_move_confirm, {

        removeModal()

        # -- update config
        config(
          ca_move(config(),
                  item = event['namespace'],
                  attribute = event['value'],
                  where = list(position = input$attribute_move_position,
                               attribute = input$attribute_move_target)))

        # -- update UI
        # remove attribute card
        removeUI(selector = paste0("div:has(> #",
                                   paste(event['namespace'], event['value'], "attribute-card-container", sep = "-")),
                 immediate = TRUE)
        # insert attribute card
        dm <- c_extract(yaml, item = event['namespace'])$data.model
        at <- c_extract(yaml, item = event['namespace'], attribute = event['value'])
        insertUI(selector = paste0("div:has(> #",
                                   paste(event['namespace'], input$attribute_move_target, "attribute-card-container", sep = "-")),
                 where = ifelse(input$attribute_move_position == "before", "beforeBegin", "afterEnd"),
                 div(class="bslib-grid-item bslib-gap-spacing html-fill-container",
                     admin_attribute_card(attribute = at,
                                          item = event['namespace'],
                                          hide = dm$hide,
                                          skip = dm$skip,
                                          refresh = dm$refresh)))

      }, ignoreInit = TRUE, once = TRUE)

    } else if(event['action'] == "attribute_delete"){

      # ------------------------------------------------------------------------
      # Delete attribute

      # -- dialog
      showModal(
        modalDialog(
          title = "Delete Attribute",
          size = "l",
          p(class = "text-danger", "This action cannot be undone!", br(),
            "Attribute parameters & corresponding item column will be lost."),
          p("Are you sure you want to delete", event['value'], "attribute?", br(),
            "Type:", paste0("delete-", event['value']), "to confirm."),
          textInput(inputId = "attribute_delete_string", label = ""),
          footer = tagList(modalButton(label = "Cancel"),
                           actionButton(inputId = "attribute_delete_confirm", label = "Confirm delete"))))

      # -- action
      observeEvent(input$attribute_delete_confirm, {

        req(input$attribute_delete_string == paste0("delete-", event['value']))
        removeModal()

        # -- drop attribute from config
        config(
          ca_drop(config(),
                  item = event['namespace'],
                  attribute = event['value']))

        # -- update UI
        # remove attribute card
        removeUI(selector = paste0("div:has(> #",
                                   paste(event['namespace'], event['value'],
                                         "attribute-card-container", sep = "-")),
                 immediate = TRUE)
        # update attribute nb
        item <- c_extract(config(), item = event['namespace'])
        shinyjs::html(id = paste0(event['namespace'], "-attribute-nb"),
                      html = admin_attribute_nb(item))
        # update skipped, refreshed & hidden (sidebar)
        shinyjs::html(id = paste0(event['namespace'], "-skipped-attributes"),
                      html = paste(item$data.model$skip, collapse = "|"))
        shinyjs::html(id = paste0(event['namespace'], "-refreshed-attributes"),
                      html = paste(item$data.model$refresh, collapse = "|"))
        shinyjs::html(id = paste0(event['namespace'], "-hidden-attributes"),
                      html = paste(item$data.model$hide, collapse = "|"))

      }, ignoreInit = TRUE)

    }

  })


  # ////////////////////////////////////////////////////////////////////////////
  # Sorting

  observeEvent(input$sorting_action, {

    # -- get event & item data.model
    event <- ktools::input_decode(input$sorting_action)
    dm <- c_extract(config(), item = event['namespace'])$data.model

    # -- dialog
    showModal(
      modalDialog(
        title = "Sorting",
        size = "l",

        # -- content
        p("Define if / how the item table should be sorted."),
        textInput(inputId = "item_ordering",
                  label = "Order",
                  value = if(is.null(dm$sort)) "" else dm$sort),
        p("Use comma (,) between attribute names.", br(),
          "Use desc() for descending order.", br(),
          "Ex: date, value or desc(date)"),

        # -- footer
        footer = tagList(
          modalButton(label = "Cancel"),
          actionButton(inputId = "sorting_confirm", label = "Save"))))

    # -- listener
    observeEvent(input$sorting_confirm, {

      # -- close window
      removeModal()

      # -- update & store
      config(
        ci_sort(config(),
                item = event['namespace'],
                sort = input$item_ordering))

      # -- update UI
      sort <- c_extract(config(), item = event['namespace'])$data.model$sort
      shinyjs::html(id = paste0(event['namespace'], "-sorting"),
                    html = if(is.null(sort)) "No sorting is defined." else paste(sort, collapse = "|"))

    }, ignoreInit = TRUE, once = TRUE)

  })

}


# -- Run the application
shinyApp(ui = ui, server = server)
