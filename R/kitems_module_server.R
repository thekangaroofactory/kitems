

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

    # -- Object types
    # note: cleaned unsupported types --
    # OBJECT_CLASS <- c("NA", "NULL",
    #                   "numeric", "integer", "complex", "logical", "character", "raw",
    #                   "double", "factor", "Date", "POSIXct", "POSIXlt")
    OBJECT_CLASS <- c("numeric", "integer", "double",
                      "logical", "character", "factor",
                      "Date", "POSIXct", "POSIXlt")

    # -- Default values
    DEFAULT_VALUES <- list("numeric" = c(NA, 0),
                           "integer" = c(NA, 0),
                           "logical" = c(NA, FALSE, TRUE),
                           "character" = c(NA, ""),
                           "double" = c(NA, 0),
                           "factor" = c(NA),
                           "Date" = c(NA),
                           "POSIXct" = c(NA),
                           "POSIXlt" = c(NA))

    # -- Default values
    DEFAULT_FUNCTIONS <- list("numeric" = c(NA),
                              "integer" = c(NA),
                              "logical" = c(NA),
                              "character" = c(NA),
                              "double" = c(NA),
                              "factor" = c(NA),
                              "Date" = c("Sys.Date"),
                              "POSIXct" = c("Sys.Date"),
                              "POSIXlt" = c("Sys.Date"))

    # -- Column name / type  template
    TEMPLATE_COLS <- data.frame(name = c("date",
                                         "name", "title", "description", "comment", "note", "status", "detail",
                                         "debit", "credit", "amount", "total", "balance",
                                         "quantity", "progress"),
                                type = c("Date",
                                         rep("character", 7),
                                         rep("double", 5),
                                         rep("integer", 2)))

    # -- Define lis of as functions
    # note: factor is not implemented in inputList.R... clean it?
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
    # Init:
    # --------------------------------------------------------------------------

    cat(MODULE, "Starting kitems module server... \n")

    # -- Get namespace
    ns <- session$ns


    # -- Build object names from module id (to access outside module)
    r_data_model <- paste0(id, "data_model")
    r_items <- paste0(id, "_items")
    #r_raw_table <- paste0(id, "_raw_table")
    #r_table <- paste0(id, "_table")

    # -- Build filenames from module id
    dm_url <- file.path(path$resource, paste0(id, "_data_model.rds"))

    # -- Build triggers names from module id (to access outside module)
    trigger_add <- paste0(id, "_trigger_new")
    trigger_save <- paste0(id, "_trigger_save")
    # trigger_update
    # trigger_delete

    # -- Declare reactive objects (for external use)
    r[[trigger_add]] <- reactiveVal(NULL)

    #r[[r_data_model]] <- reactiveVal(NULL)
    r[[r_items]] <- reactiveVal(NULL)


    # --------------------------------------------------------------------------
    # Read/Write Resources (data model)
    # --------------------------------------------------------------------------

    # -- Read data model
    if(file.exists(dm_url)){

      data.model <- readRDS(dm_url)
      cat(MODULE, "Read data model done \n")

    }

    # -- Write data model (auto save)
    observeEvent(r[[r_data_model]](), {

      # -- Write & notify
      saveRDS(r[[r_data_model]](), file = dm_url)
      cat(MODULE, "Data model saved \n")

    }, ignoreInit = TRUE)


    # --------------------------------------------------------------------------
    # Load the data:
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

    # -- Store into communication object & notify
    r[[r_items]]<- reactiveVal(items)


    # --------------------------------------------------------------------------
    # Auto save the data:
    # --------------------------------------------------------------------------

    # -- Auto save items (check parameter)
    if(autosave)
      observeEvent(r[[r_items]](), {

        # -- Write
        kfiles::write_data(data = r[[r_items]](),
                           file = file,
                           path = path$data)

        # -- Notify
        cat(MODULE, "[EVENT] Item list has been (auto) saved \n")

      }, ignoreInit = TRUE)


    # -- Declare trigger: save items
    r[[trigger_save]] <- reactiveVal(0)

    # -- Observe trigger
    observeEvent(r[[trigger_save]](), {

      # -- Write
      kfiles::write_data(data = r[[r_items]](),
                         file = file,
                         path = path$data)

      # -- Notify
      cat(MODULE, "[TRIGGER] Item list has been saved \n")

    }, ignoreInit = TRUE)


    # --------------------------------------------------------------------------
    # Check data model integrity:
    # --------------------------------------------------------------------------
    # Code cleanup note: sequence should be load data.mode, load data, check integrity
    # then only store into reactive values
    # Declare observers after that init sequence

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

    # -- Store (either content of the RDS or the server function input) & notify
    r[[r_data_model]] <- reactiveVal(data.model)


    # **************************************************************************
    # *** CODE REVIEW : END done
    # **************************************************************************



    # -------------------------------------
    # Views:
    # -------------------------------------

    # -- item table view
    view_items <- reactive({

      if(!is.null(r[[r_items]]())){

        # -- get filter from data model
        filter_cols <- dm_filter(r[[r_data_model]]())

        # -- apply filter
        value <- if(is.null(filter_cols)){

          r[[r_items]]()

        } else {

          r[[r_items]]()[-which(names(r[[r_items]]()) %in% filter_cols)]

        }

        # -- apply column name mask
        colnames(value) <- gsub(".", " ", colnames(value), fixed = TRUE)
        colnames(value) <- gsub("_", " ", colnames(value), fixed = TRUE)
        colnames(value) <- stringr::str_to_title(colnames(value))

      } else value <- NULL

      # -- return
      value

    })


    # -------------------------------------
    # Outputs:
    # -------------------------------------

    # Raw view for admin
    output$raw_item_table <- DT::renderDT(r[[r_items]](),
                                          rownames = FALSE,
                                          options = list(lengthMenu = c(5, 10, 15), pageLength = 5, dom = "t", scrollX = TRUE),
                                          selection = list(mode = 'single', target = "row", selected = NULL))

    # Masked view for admin
    output$view_item_table <- DT::renderDT(view_items(),
                                           rownames = FALSE,
                                           selection = list(mode = 'single', target = "row", selected = NULL))


    # -- colClasses
    # output$data_model <- DT::renderDT(data.frame(as.list(colClasses())),
    #                                   rownames = FALSE,
    #                                   options = list(lengthMenu = c(5, 10, 15), pageLength = 5, dom = "t", scrollX = TRUE),
    #                                   selection = list(mode = 'single', target = "row", selected = NULL))

    # -- colClasses
    output$data_model <- DT::renderDT(r[[r_data_model]](),
                                      rownames = TRUE,
                                      options = list(lengthMenu = c(5, 10, 15), pageLength = 10, dom = "t", scrollX = TRUE),
                                      selection = list(mode = 'single', target = "row", selected = NULL))



    # Masked view for user
    # TODO: add user view (add function params for renderDT...)




    # -------------------------------------
    # Action buttons:
    # -------------------------------------

    # -- danger zone
    output$danger_zone <- renderUI({

      tagList(

        # -- select column name
        selectizeInput(inputId = ns("dz_col_name"),
                       label = "Name",
                       choices = colnames(r[[r_items]]()),
                       selected = NULL,
                       options = list(create = FALSE,
                                      placeholder = 'Type or select an option below',
                                      onInitialize = I('function() { this.setValue(""); }'))),

        # -- delete
        actionButton(ns("dz_delete_col"), label = "Delete"))

    })

    # -- delete column
    observeEvent(input$dz_delete_col, {

      # -- check
      req(input$dz_col_name)

      cat("[BTN] Delete column:", input$dz_col_name, "\n")

      # -- drop column! & store
      items <- r[[r_items]]()
      items[input$dz_col_name] <- NULL
      r[[r_items]](items)

      # -- update data model & store
      dm <- r[[r_data_model]]()
      dm <- dm[dm$name != input$dz_col_name, ]
      r[[r_data_model]](dm)

    })


    # -- define inputs
    output$action_buttons <- renderUI({

      # check
      if(is.null(r[[r_items]]())){

        # create data
        actionButton(ns("create_data"), label = "Create")

      } else {

        tagList(

          # add column name
          selectizeInput(inputId = ns("add_col_name"),
                         label = "Name",
                         choices = TEMPLATE_COLS$name[!TEMPLATE_COLS$name %in% colnames(r[[r_items]]())],
                         selected = NULL,
                         options = list(create = TRUE,
                                        placeholder = 'Type or select an option below',
                                        onInitialize = I('function() { this.setValue(""); }'))),

          # add column type
          selectizeInput(inputId = ns("add_col_type"),
                         label = "Type",
                         choices = OBJECT_CLASS,
                         selected = NULL,
                         options = list(create = FALSE,
                                        placeholder = 'Type or select an option below',
                                        onInitialize = I('function() { this.setValue(""); }'))),

          # add column default.val
          selectizeInput(inputId = ns("add_col_default_val"),
                         label = "Default value",
                         choices = NULL,
                         selected = NULL,
                         options = list(create = TRUE,
                                        placeholder = 'Type or select an option below',
                                        onInitialize = I('function() { this.setValue(""); }'))),

          # add column default.fun
          selectizeInput(inputId = ns("add_col_default_fun"),
                         label = "Default function",
                         choices = NULL,
                         selected = NULL,
                         options = list(create = TRUE,
                                        placeholder = 'Type or select an option below',
                                        onInitialize = I('function() { this.setValue(""); }'))),

          # add skip
          checkboxInput(inputId = ns("add_col_skip"),
                        label = "Skip (input form)",
                        value = FALSE),

          # add column button
          actionButton(ns("add_col"), label = "Add column"),

          # order column name
          selectizeInput(inputId = ns("order_cols"),
                         label = "Select cols order",
                         choices = colnames(r[[r_items]]()),
                         selected = colnames(r[[r_items]]()),
                         multiple = TRUE),

          # order column button
          actionButton(ns("sort_col"), label = "Reorder")

        ) # end tagList

      }})


    # -- update add_col_type given add_col_name
    observeEvent(input$add_col_name, {

      # -- check if input in template
      if(tolower(input$add_col_name) %in% TEMPLATE_COLS$name)

        updateSelectizeInput(session = session,
                             inputId = "add_col_type",
                             choices = OBJECT_CLASS,
                             selected = TEMPLATE_COLS[TEMPLATE_COLS$name == input$add_col_name, ]$type)})


    # -- update add_col_type given add_col_name
    observeEvent(input$add_col_type, {

      # -- check if input in template
      updateSelectizeInput(session = session,
                           inputId = "add_col_default_val",
                           choices = DEFAULT_VALUES[[input$add_col_type]],
                           selected = NULL)

      # -- check if input in template
      updateSelectizeInput(session = session,
                           inputId = "add_col_default_fun",
                           choices = DEFAULT_FUNCTIONS[[input$add_col_type]],
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


    # -- BTN add_col
    observeEvent(input$add_col, {

      # check
      req(input$add_col_name,
          input$add_col_type)

      cat("[BTN] Add column \n")

      # Add attribute to the data model & store
      dm <- r[[r_data_model]]()
      dm <- dm_add_attribute(data.model = dm,
                             name = input$add_col_name,
                             type = input$add_col_type,
                             default.val = input$add_col_default_val,
                             default.fun = input$add_col_default_fun,
                             skip = input$add_col_skip,
                             filter = input$add_col_filter)
      r[[r_data_model]](dm)

      # -- get default value
      value <- dm_get_default(data.model = dm, name = input$add_col_name)

      # Add column to items & store
      items <- attribute_add(r[[r_items]](), name = input$add_col_name, type = input$add_col_type, fill = value, coerce = CLASS_FUNCTIONS)
      r[[r_items]](items)

    })


    # -- BTN sort_col
    observeEvent(input$sort_col, {

      # -- Check
      req(length(input$order_cols) == dim(r[[r_items]]())[2])

      cat("[BTN] Reorder column \n")

      # -- Reorder items & store
      r[[r_items]](r[[r_items]]()[input$order_cols])

      # -- Reorder data model & store
      dm <- r[[r_data_model]]
      dm <- dm[match(input$order_cols, dm$name), ]
      r[[r_data_model]](dm)

    })


    # -------------------------------------
    # Filter view:
    # -------------------------------------

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



    # -------------------------------------
    # Triggers:
    # -------------------------------------

    # add
    #r[[trigger_add]]


    # -------------------------------------
    # Create item:
    # -------------------------------------

    # -- btn: new item
    output$new_item_btn <- renderUI(actionButton(inputId = ns("new_item_btn"),
                                                 label = "New item"))

    # -- new_item_btn
    observeEvent(input$new_item_btn, {

      showModal(modalDialog(inputList(ns, item = NULL, update = FALSE, colClasses = dm_colClasses(r[[r_data_model]]), skip = skip_cols()),
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
      input_values <- get_input_values(input, dm_colClasses(r[[r_data_model]]))

      # -- create item based on input list
      cat("--  Create item \n")
      item <- item_create(values = input_values, data.model = r[[r_data_model]], coerce = CLASS_FUNCTIONS)

      # -- add item to list & store
      cat("--  Add item to list \n")
      item_list <- item_add(r[[r_items]](), item)
      r[[r_items]](item_list)

    })


  })
}

