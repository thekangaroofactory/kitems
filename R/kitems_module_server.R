

#' Title
#'
#' @param id
#' @param r
#' @param file
#' @param path
#' @param data.model
#' @param create
#' @param autosave
#'
#'
#' @details
#'
#'
#' @examples


# ------------------------------------------------------------------------------
# Shiny module server logic
# ------------------------------------------------------------------------------

kitemsManager_Server <- function(id, r, file, path,
                                 data.model = NULL,
                                 create = TRUE, autosave = TRUE) {
  moduleServer(id, function(input, output, session) {

    # --------------------------------------------------------------------------
    # Declare config parameters:
    # --------------------------------------------------------------------------

    # -- Build log pattern
    MODULE <- paste0("[", id, "]")

    # -- Object types (supported)
    OBJECT_CLASS <- c("numeric",
                      "integer",
                      "double",
                      "logical",
                      "character",
                      "factor",
                      "Date",
                      "POSIXct",
                      "POSIXlt")

    # -- Default values
    DEFAULT_VALUES <- list("numeric" = c(NA, 0),
                           "integer" = c(NA, 0),
                           "double" = c(NA, 0),
                           "logical" = c(NA, FALSE, TRUE),
                           "character" = c(NA, ""),
                           "factor" = c(NA),
                           "Date" = c(NA),
                           "POSIXct" = c(NA),
                           "POSIXlt" = c(NA))

    # -- Default values
    DEFAULT_FUNCTIONS <- list("numeric" = c(NA),
                              "integer" = c(NA),
                              "double" = c(NA),
                              "logical" = c(NA),
                              "character" = c(NA),
                              "factor" = c(NA),
                              "Date" = c("Sys.Date"),
                              "POSIXct" = c("Sys.Date"),
                              "POSIXlt" = c("Sys.Date"))

    # -- Define lis of as functions
    CLASS_FUNCTIONS <- list("numeric" = "as.numeric",
                            "integer" = "as.integer",
                            "double" = "as.double",
                            "logical" = "as.logical",
                            "character" = "as.character",
                            "factor" = "as.factor",
                            "Date" = ".Date",
                            "POSIXct" = "as.POSIXct",
                            "POSIXlt" = "as.POSIXlt")


    # --------------------------------------------------------------------------
    # Declare templates:
    # --------------------------------------------------------------------------

    # -- Data model template
    TEMPLATE_DATA_MODEL <- data.frame(name = c("date",
                                               "name", "title", "description", "comment", "note", "status", "detail",
                                               "debit", "credit", "amount", "total", "balance",
                                               "quantity", "progress"),
                                      type = c("Date",
                                               rep("character", 7),
                                               rep("double", 5),
                                               rep("integer", 2)))


    # --------------------------------------------------------------------------
    # Init:
    # --------------------------------------------------------------------------

    cat(MODULE, "Starting kitems module server... \n")

    # -- Get namespace
    ns <- session$ns


    # -- Build filename from module id
    dm_url <- file.path(path$resource, paste0(id, "_data_model.rds"))


    # -- Build object names from module id (to access outside module)
    r_data_model <- paste0(id, "data_model")
    r_items <- paste0(id, "_items")

    # -- Declare reactive objects (for external use)
    r[[r_items]] <- reactiveVal(NULL)


    # -- Build triggers names from module id (to access outside module)
    trigger_add <- paste0(id, "_trigger_new")
    trigger_save <- paste0(id, "_trigger_save")

    # -- Declare reactive objects (for external use)
    r[[trigger_add]] <- reactiveVal(NULL)
    r[[trigger_save]] <- reactiveVal(0)


    # --------------------------------------------------------------------------
    # Read data model:
    # --------------------------------------------------------------------------

    # -- Check url
    if(file.exists(dm_url)){

      data.model <- readRDS(dm_url)
      cat(MODULE, "Read data model done \n")}


    # --------------------------------------------------------------------------
    # Read the data (items):
    # --------------------------------------------------------------------------

    # -- Init
    items <- NULL

    # -- Check for NULL data model (then no reason to try loading)
    if(!is.null(data.model)){

      # -- Extract colClasses from data model (can't use the reactiveVal without wrapper)
      col.classes <- dm_colClasses(data.model)

      # -- Try load (see read_data for details about returns)
      items <- kfiles::read_data(file = file,
                                 path = path$data,
                                 colClasses = col.classes,
                                 create = create)

      # -- check output size (will trigger showing the create data btn)
      if(all(dim(items) == c(0,0)))
        items <- NULL

      cat(MODULE, "Read data done \n")

    }


    # --------------------------------------------------------------------------
    # Check data model integrity:
    # --------------------------------------------------------------------------

    # -- Check for NULL data mode + data.frame
    if(!is.null(data.model) & !is.null(items)){

      result <- dm_check_integrity(data.model, items)

      # -- Check feedback (otherwise value is TRUE)
      if(is.data.frame(result)){

        cat("[Warning] Data model not synchronized with items data.frame! \n")

        # -- Update data model & save
        data.model <- result
        saveRDS(data.model, file = dm_url)
        cat(MODULE, "Data model saved \n")

      }}


    # --------------------------------------------------------------------------
    # Store into reactive values:
    # --------------------------------------------------------------------------

    # -- Store data model (either content of the RDS or the server function input)
    r[[r_data_model]] <- reactiveVal(data.model)

    # -- Store items
    r[[r_items]]<- reactiveVal(items)


    # --------------------------------------------------------------------------
    # Auto save the data model:
    # --------------------------------------------------------------------------

    # -- Observe data model
    observeEvent(r[[r_data_model]](), {

      # -- Write & notify
      saveRDS(r[[r_data_model]](), file = dm_url)
      cat(MODULE, "Data model saved \n")

    }, ignoreInit = TRUE)


    # --------------------------------------------------------------------------
    # Auto save the data:
    # --------------------------------------------------------------------------

    # -- Check parameter & observe items
    if(autosave)
      observeEvent(r[[r_items]](), {

        # -- Write
        kfiles::write_data(data = r[[r_items]](),
                           file = file,
                           path = path$data)

        # -- Notify
        cat(MODULE, "[EVENT] Item list has been (auto) saved \n")

      }, ignoreInit = TRUE)


    # --------------------------------------------------------------------------
    # Declare triggers:
    # --------------------------------------------------------------------------

    # -- Save (items)
    observeEvent(r[[trigger_save]](), {

      # -- Write
      kfiles::write_data(data = r[[r_items]](),
                         file = file,
                         path = path$data)

      # -- Notify
      cat(MODULE, "[TRIGGER] Item list has been saved \n")

    }, ignoreInit = TRUE)


    # --------------------------------------------------------------------------
    # Declare views:
    # --------------------------------------------------------------------------

    # -- Item table view
    view_items <- reactive({

      if(!is.null(r[[r_items]]())){

        # -- Get filter from data model
        filter_cols <- dm_filter(r[[r_data_model]]())

        # -- Apply filter
        value <- if(is.null(filter_cols)){

          r[[r_items]]()

        } else {

          r[[r_items]]()[-which(names(r[[r_items]]()) %in% filter_cols)]

        }

        # -- Apply attribute/column name mask
        colnames(value) <- gsub(".", " ", colnames(value), fixed = TRUE)
        colnames(value) <- gsub("_", " ", colnames(value), fixed = TRUE)
        colnames(value) <- stringr::str_to_title(colnames(value))

      } else value <- NULL

      # -- Return
      value

    })


    # --------------------------------------------------------------------------
    # Declare outputs:
    # --------------------------------------------------------------------------

    # -- Raw view for admin
    output$raw_item_table <- DT::renderDT(r[[r_items]](),
                                          rownames = FALSE,
                                          options = list(lengthMenu = c(5, 10, 15), pageLength = 5, dom = "t", scrollX = TRUE),
                                          selection = list(mode = 'single', target = "row", selected = NULL))

    # -- Masked view for admin
    output$view_item_table <- DT::renderDT(view_items(),
                                           rownames = FALSE,
                                           selection = list(mode = 'single', target = "row", selected = NULL))

    # -- colClasses
    output$data_model <- DT::renderDT(r[[r_data_model]](),
                                      rownames = TRUE,
                                      options = list(lengthMenu = c(5, 10, 15), pageLength = 10, dom = "t", scrollX = TRUE),
                                      selection = list(mode = 'single', target = "row", selected = NULL))


    # --------------------------------------------------------------------------
    # Create data model:
    # --------------------------------------------------------------------------

    output$create_zone <- renderUI(

      # check for null data model
      if(is.null(r[[r_data_model]]()))
        actionButton(ns("create_data"), label = "Create"))


    # --------------------------------------------------------------------------
    # Declare danger zone:
    # --------------------------------------------------------------------------

    # -- Toggle btn
    output$danger_btn <- renderUI(

      # -- Check for NULL data model
      if(!is.null(r[[r_data_model]]()))
        shinyWidgets::materialSwitch(inputId = ns("dz_toggle"),
                                     label = "Danger zone",
                                     value = FALSE,
                                     status = "danger"))


    # -- Observe Toggle btn
    observeEvent(input$dz_toggle,

                 # -- Define output
                 output$danger_zone <- renderUI(

                   if(input$dz_toggle)
                     shinydashboard::box(title = "Delete attribute", status = "danger", width = 4,

                                         tagList(

                                           # -- select attribute name
                                           selectizeInput(inputId = ns("dz_att_name"),
                                                          label = "Name",
                                                          choices = colnames(r[[r_items]]()),
                                                          selected = NULL,
                                                          options = list(create = FALSE,
                                                                         placeholder = 'Type or select an option below',
                                                                         onInitialize = I('function() { this.setValue(""); }'))),

                                           # -- delete
                                           actionButton(ns("dz_delete_att"), label = "Delete")))))


    # -- Observe button: delete attribute
    observeEvent(input$dz_delete_att, {

      # -- check
      req(input$dz_att_name)

      cat("[BTN] Delete attribute:", input$dz_att_name, "\n")

      # -- drop column! & store
      items <- r[[r_items]]()
      items[input$dz_att_name] <- NULL
      r[[r_items]](items)

      # -- update data model & store
      dm <- r[[r_data_model]]()
      dm <- dm[dm$name != input$dz_att_name, ]
      r[[r_data_model]](dm)

    })


    # --------------------------------------------------------------------------
    # Create data / add attribute:
    # --------------------------------------------------------------------------

    # -- define inputs
    output$action_buttons <- renderUI({

      # check
      if(is.null(r[[r_items]]()))
        NULL

      else {

        tagList(

          # attribute name
          selectizeInput(inputId = ns("add_att_name"),
                         label = "Name",
                         choices = TEMPLATE_DATA_MODEL$name[!TEMPLATE_DATA_MODEL$name %in% colnames(r[[r_items]]())],
                         selected = NULL,
                         options = list(create = TRUE,
                                        placeholder = 'Type or select an option below',
                                        onInitialize = I('function() { this.setValue(""); }'))),

          # attribute type
          selectizeInput(inputId = ns("add_att_type"),
                         label = "Type",
                         choices = OBJECT_CLASS,
                         selected = NULL,
                         options = list(create = FALSE,
                                        placeholder = 'Type or select an option below',
                                        onInitialize = I('function() { this.setValue(""); }'))),

          # attribute default.val
          selectizeInput(inputId = ns("add_att_default_val"),
                         label = "Default value",
                         choices = NULL,
                         selected = NULL,
                         options = list(create = TRUE,
                                        placeholder = 'Type or select an option below',
                                        onInitialize = I('function() { this.setValue(""); }'))),

          # attribute default.fun
          selectizeInput(inputId = ns("add_att_default_fun"),
                         label = "Default function",
                         choices = NULL,
                         selected = NULL,
                         options = list(create = TRUE,
                                        placeholder = 'Type or select an option below',
                                        onInitialize = I('function() { this.setValue(""); }'))),

          # skip
          checkboxInput(inputId = ns("add_att_skip"),
                        label = "Skip (input form)",
                        value = FALSE),

          # add attribute button
          actionButton(ns("add_att"), label = "Add attribute")

        ) # end tagList

      }})


    # -- update add_att_type given add_att_name
    observeEvent(input$add_att_name, {

      # -- check if input in template
      if(tolower(input$add_att_name) %in% TEMPLATE_DATA_MODEL$name)

        updateSelectizeInput(session = session,
                             inputId = "add_att_type",
                             choices = OBJECT_CLASS,
                             selected = TEMPLATE_DATA_MODEL[TEMPLATE_DATA_MODEL$name == input$add_att_name, ]$type)})


    # -- update add_att_type given add_att_name
    observeEvent(input$add_att_type, {

      # -- check if input in template
      updateSelectizeInput(session = session,
                           inputId = "add_att_default_val",
                           choices = DEFAULT_VALUES[[input$add_att_type]],
                           selected = NULL)

      # -- check if input in template
      updateSelectizeInput(session = session,
                           inputId = "add_att_default_fun",
                           choices = DEFAULT_FUNCTIONS[[input$add_att_type]],
                           selected = NULL)

    })


    # -- BTN create_data
    observeEvent(input$create_data, {

      cat("[BTN] Create data \n")

      # -- init parameters (id)
      colClasses <- c("id" = "numeric")
      default_fun <- c("id" = "ktools::getTimestamp")
      filter <- c("id")
      skip <- c("id")

      # -- init data model & store
      dm <- data_model(colClasses, default.val = NULL, default.fun = default_fun, filter = filter, skip = skip)
      r[[r_data_model]](dm)

      # -- init items
      items <- kfiles::read_data(file = file,
                                 path = path$data,
                                 colClasses = colClasses,
                                 create = TRUE)

      # -- store items
      r[[r_items]](items)

    })


    # -- BTN add_att
    observeEvent(input$add_att, {

      # check
      req(input$add_att_name,
          input$add_att_type)

      cat("[BTN] Add column \n")

      # Add attribute to the data model & store
      dm <- r[[r_data_model]]()
      dm <- dm_add_attribute(data.model = dm,
                             name = input$add_att_name,
                             type = input$add_att_type,
                             default.val = input$add_att_default_val,
                             default.fun = input$add_att_default_fun,
                             skip = input$add_att_skip,
                             filter = FALSE)
      r[[r_data_model]](dm)

      # -- get default value
      value <- dm_get_default(data.model = dm, name = input$add_att_name)

      # Add column to items & store
      items <- item_add_attribute(r[[r_items]](), name = input$add_att_name, type = input$add_att_type, fill = value, coerce = CLASS_FUNCTIONS)
      r[[r_items]](items)

    })


    # --------------------------------------------------------------------------
    # Sort attributes / columns:
    # --------------------------------------------------------------------------

    # -- define inputs
    output$sort_buttons <- renderUI(

      # -- check NULL data model
      if(is.null(r[[r_items]]()))
        NULL

      else {

        tagList(

          # order attribute name
          selectizeInput(inputId = ns("order_cols"),
                         label = "Select cols order",
                         choices = colnames(r[[r_items]]()),
                         selected = colnames(r[[r_items]]()),
                         multiple = TRUE),

          # order attribute button
          actionButton(ns("sort_col"), label = "Reorder"))})


    # -- BTN sort_col
    observeEvent(input$sort_col, {

      # -- Check
      req(length(input$order_cols) == dim(r[[r_items]]())[2])

      cat("[BTN] Reorder column \n")

      # -- Reorder items & store
      r[[r_items]](r[[r_items]]()[input$order_cols])

      # -- Reorder data model & store
      dm <- r[[r_data_model]]()
      dm <- dm[match(input$order_cols, dm$name), ]
      r[[r_data_model]](dm)

    })


    # --------------------------------------------------------------------------
    # Filter view:
    # --------------------------------------------------------------------------

    # inputs
    output$filter_buttons <- renderUI({

      # -- init params
      filter_cols <- dm_filter(r[[r_data_model]]())

      onInitialize <- if(is.null(filter_cols))
        I('function() { this.setValue(""); }')
      else
        NULL

      # -- define input
      selectizeInput(inputId = ns("filter_col"),
                     label = "Filter columns",
                     choices = colnames(r[[r_items]]()),
                     selected = filter_cols,
                     multiple = TRUE,
                     options = list(create = FALSE,
                                    placeholder = 'Type or select an option below',
                                    onInitialize = onInitialize))

    })

    # observe filter input
    observeEvent(input$filter_col, {

      cat("[BTN] Filter columns:", input$filter_col, "\n")
      dm <- r[[r_data_model]]()

      # -- Check NULL data model
      if(!is.null(dm)){
        dm <- dm_filter_set(data.model = dm, filter = input$filter_col)
        r[[r_data_model]](dm)}

    }, ignoreInit = TRUE, ignoreNULL = FALSE)



    # --------------------------------------------------------------------------
    # Triggers:
    # --------------------------------------------------------------------------

    # add
    #r[[trigger_add]]


    # --------------------------------------------------------------------------
    # Create item:
    # --------------------------------------------------------------------------

    # -- btn: new item
    output$new_item_btn <- renderUI(actionButton(inputId = ns("new_item_btn"),
                                                 label = "New item"))

    # -- new_item_btn
    observeEvent(input$new_item_btn, {

      showModal(modalDialog(inputList(ns, item = NULL, update = FALSE, colClasses = dm_colClasses(r[[r_data_model]]()), skip = dm_skip(r[[r_data_model]]())),
                            title = "Create",
                            footer = tagList(
                              modalButton("Cancel"),
                              actionButton(ns("create_item"), "Create"))))

    })

    # -- new item
    observeEvent(input$create_item, {

      cat(MODULE, "[EVENT] Create item \n")

      # -- close modal
      removeModal()

      # -- get list of input values & name it
      cat("--  Get list of input values \n")
      input_values <- get_input_values(input, dm_colClasses(r[[r_data_model]]()))

      # -- create item based on input list
      cat("--  Create item \n")
      item <- item_create(values = input_values, data.model = r[[r_data_model]](), coerce = CLASS_FUNCTIONS)

      # -- add item to list & store
      cat("--  Add item to list \n")
      item_list <- item_add(r[[r_items]](), item)
      r[[r_items]](item_list)

    })


  })
}

