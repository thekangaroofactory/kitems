

#' Title
#'
#' @param id
#' @param r
#' @param file
#' @param path
#' @param col.classes
#' @param default.val a named vector, providing default values. In case an attribute of the data model has no default value,
#' it will be NA.
#' @param default.fun
#' @param filter.cols
#' @param create
#' @param autosave
#'
#' @return
#' @export
#'
#' @details
#'
#' Resources: colClasses, default.val & default.fun are taken from the arguments by default.
#'
#' @examples


# ------------------------------------------------------------------------------
# Shiny module server logic
# ------------------------------------------------------------------------------

kitemsManager_Server <- function(id, r, file, path,
                                 col.classes = NA, default.val = NULL, default.fun = NULL, filter.cols = NULL,
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
    CLASS_FUNCTIONS <- list("numeric" = as.numeric,
                            "integer" = as.integer,
                            "double" = as.double,
                            "logical" = as.logical,
                            "character" = as.character,
                            "factor" = as.factor,
                            "Date" = .Date,
                            "POSIXct" = as.POSIXct,
                            "POSIXlt" = as.POSIXlt)


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

    # -- Build triggers names from module id (to access outside module)
    trigger_add <- paste0(id, "_trigger_new")
    trigger_save <- paste0(id, "_trigger_save")
    # trigger_update
    # trigger_delete


    # -- Declare reactive objects (for internal use)
    colClasses <- reactiveVal(NULL)
    default_val <- reactiveVal(NULL)
    default_fun <- reactiveVal(NULL)
    filter_cols <- reactiveVal(NULL)


    # -- Declare reactive objects (for external use)
    r[[trigger_add]] <- reactiveVal(NULL)


    # ******************************************
    # HACK TO BE REPLACED

    cat("[***] --- HACK TO BE REMOVED --- [***] \n")

    # -- skip mechanism: implement it in data model definition
    skip <- c("id")

    # -- end HACK
    # ******************************************



    # --------------------------------------------------------------------------
    # Load Resources:
    # --------------------------------------------------------------------------

    # -- colClasses
    target_url <- file.path(path$resource, paste0(id, "_colClasses.rds"))
    if(file.exists(target_url))
      col.classes <- readRDS(target_url)

    colClasses(col.classes)

    # save colClasses
    observeEvent(colClasses(), {

      # -- Write & notify
      saveRDS(colClasses(), file = file.path(path$resource, paste0(id, "_colClasses.rds")))
      cat(MODULE, "colClasses saved \n")

    }, ignoreInit = TRUE)


    # -- Filters
    target_url <- file.path(path$resource, paste0(id, "_filterCols.rds"))
    if(file.exists(target_url))
      filter.cols <- readRDS(target_url)

    filter_cols(filter.cols)


    # save filter_cols
    observeEvent(filter_cols(), {

      # -- Write & notify
      saveRDS(filter_cols(), file = file.path(path$resource, paste0(id, "_filterCols.rds")))
      cat(MODULE, "filter_cols saved \n")

    }, ignoreInit = TRUE, ignoreNULL = FALSE)


    # -- Default values
    target_url <- file.path(path$resource, paste0(id, "_defaultVal.rds"))
    if(file.exists(target_url))
      default.val <- readRDS(target_url)

    default_val(default.val)


    # save default_val
    observeEvent(default_val(), {

      # -- Write & notify
      saveRDS(default_val(), file = file.path(path$resource, paste0(id, "_defaultVal.rds")))
      cat(MODULE, "default_val saved \n")

    }, ignoreInit = TRUE, ignoreNULL = FALSE)


    # -- Default functions
    target_url <- file.path(path$resource, paste0(id, "_defaultFun.rds"))
    if(file.exists(target_url))
      default.fun <- readRDS(target_url)

    default_fun(default.fun)


    # save default_val
    observeEvent(default_fun(), {

      # -- Write & notify
      saveRDS(default_fun(), file = file.path(path$resource, paste0(id, "_defaultFun.rds")))
      cat(MODULE, "default_fun saved \n")

    }, ignoreInit = TRUE, ignoreNULL = FALSE)


    # --------------------------------------------------------------------------
    # Load the data:
    # --------------------------------------------------------------------------

    # -- Try load (see read_data for details about returns)
    items <- kfiles::read_data(file = file,
                               path = path$data,
                               colClasses = col.classes,
                               create = create)

    # -- check output size (will trigger showing the create data btn)
    if(all(dim(items) == c(0,0)))
      items <- NULL

    # -- Notify
    cat(MODULE, "Read data done \n")

    # -- Store into communication object
    r[[r_items]] <- reactiveVal(items)

    # -- Store data model into communication object
    r[[r_data_model]] <- reactive(data_model(colClasses(), default_val(), default_fun()))



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


    # **************************************************************************
    # *** CODE REVIEW : END done
    # **************************************************************************



    # -------------------------------------
    # Views:
    # -------------------------------------

    # item table display view
    view_items <- reactive({

      if(!is.null(r[[r_items]]())){

        # apply column filter
        value <- if(is.null(filter_cols())){

          r[[r_items]]()

        } else {

          r[[r_items]]()[-which(names(r[[r_items]]()) %in% filter_cols())]

        }

        # apply column name mask
        colnames(value) <- gsub(".", " ", colnames(value), fixed = TRUE)
        colnames(value) <- gsub("_", " ", colnames(value), fixed = TRUE)
        colnames(value) <- stringr::str_to_title(colnames(value))

      } else value <- NULL

      # return
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

      # -- drop column! & store
      items <- r[[r_items]]()
      items[input$dz_col_name] <- NULL
      r[[r_items]](items)

      # -- update colClasses & store
      tmp_colClasses <- colClasses()
      tmp_colClasses <- tmp_colClasses[!names(tmp_colClasses) %in% input$dz_col_name]
      colClasses(tmp_colClasses)

      # -- update default_val & store
      tmp_default_val <- default_val()
      tmp_default_val <- tmp_default_val[!names(tmp_default_val) %in% input$dz_col_name]
      default_val(tmp_default_val)


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
                           selected = NULL)})



    # -- BTN create_data
    observeEvent(input$create_data, {

      cat("[BTN] Create data \n")

      # -- init colClasses
      tmp_colClasses <- c("id" = "numeric")

      # -- init items
      items <- kfiles::read_data(file = file,
                                 path = path$data,
                                 colClasses = tmp_colClasses,
                                 create = TRUE)

      # -- store items and colClasses
      r[[r_items]](items)
      colClasses(tmp_colClasses)

    })


    # -- BTN add_col
    observeEvent(input$add_col, {

      # check
      req(input$add_col_name,
          input$add_col_type)

      cat("[BTN] Add column \n")

      # create and store
      items <- attribute_add(r[[r_items]](), name = input$add_col_name, type = input$add_col_type, fill = NA)
      r[[r_items]](items)

      # update & store colClasses
      tmp_colClasses <- colClasses()
      tmp_colClasses[input$add_col_name] <- input$add_col_type
      colClasses(tmp_colClasses)

      # -- update & store default_val (if not NULL)
      if(input$add_col_default_val != ""){
        tmp_default_val <- default_val()
        tmp_default_val[input$add_col_name] <- input$add_col_default_val
        default_val(tmp_default_val)}

    })


    # -- BTN sort_col
    observeEvent(input$sort_col, {

      # check
      req(length(input$order_cols) == dim(r[[r_items]]())[2])

      cat("[BTN] Reorder column \n")

      # reorder items and store
      r[[r_items]](r[[r_items]]()[input$order_cols])

      # reorder colClasses & store
      colClasses(colClasses()[input$order_cols])

    })


    # -------------------------------------
    # Filter view:
    # -------------------------------------

    # inputs
    output$filter_buttons <- renderUI({

      onInitialize <- if(is.null(filter_cols()))
        I('function() { this.setValue(""); }')
      else
        NULL

      selectizeInput(inputId = ns("filter_col"),
                     label = "Filter columns",
                     choices = colnames(r[[r_items]]()),
                     selected = filter_cols(),
                     multiple = TRUE,
                     options = list(create = FALSE,
                                    placeholder = 'Type or select an option below',
                                    onInitialize = onInitialize))

    })

    # observe filter input
    observeEvent(input$filter_col, {

      cat("Filter columns:", input$filter_col, "\n")
      filter_cols(input$filter_col)

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

      showModal(modalDialog(inputList(ns, item = NULL, update = FALSE, colClasses = colClasses(), skip = skip),
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
      input_values <- get_input_values(input, colClasses())

      # -- create item based on input list
      cat("--  Create item \n")
      item <- item_create(input_values, colClasses(), default_val(), default_fun(), coerce_functions = CLASS_FUNCTIONS)

      # -- add item to list & store
      cat("--  Add item to list \n")
      item_list <- item_add(r[[r_items]](), item)
      r[[r_items]](item_list)

    })


  })
}

