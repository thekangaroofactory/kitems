

# --------------------------------------------------------------------------------
# Shiny module: Data
# --------------------------------------------------------------------------------

# -- Library
library(DT)
library(stringr)

# -------------------------------------
# Server logic
# -------------------------------------

kitemsManager_Server <- function(id, r, path, file = NULL, col.classes = NULL, filter.cols = NULL) {
  moduleServer(id, function(input, output, session) {


    # -------------------------------------
    # Init:
    # -------------------------------------

    cat(paste0("-- [", id, "] Starting kitems module server... \n"))

    # get namespace
    ns <- session$ns

    # declare communication objects
    r_items <- paste0(id, "_items")
    #r_raw_table <- paste0(id, "_raw_table")
    #r_table <- paste0(id, "_table")

    # declare reactive objects (internal)
    colClasses <- reactiveVal(NULL)
    filter_cols <- reactiveVal(NULL)

    # declare triggers
    trigger_add <- paste0(id, "_trigger_new")
    # trigger_update
    # trigger_delete

    # declare config parameters
    CREATE_FILE <- FALSE

    COL_CLASSES_LIST <- c("integer", "double", "character", "Date", "POSIXct", "logical")

    TEMPLATE_COLS <- data.frame(name = c("date", "target.date",
                                         "name", "title", "description", "comment", "status",
                                         "debit", "credit", "total", "balance", "progress"),
                                type = c("Date", "POSIXct",
                                         rep("character", 5),
                                         rep("double", 4), "integer"))


    # -------------------------------------
    # Load Resources:
    # -------------------------------------

    target_url <- file.path(path$resource, paste0(id, "_colClasses.rds"))
    if(file.exists(target_url))
      col.classes <- readRDS(target_url)

    target_url <- file.path(path$resource, paste0(id, "_filterCols.rds"))
    if(file.exists(target_url))
      filter.cols <- readRDS(target_url)


    # -------------------------------------
    # Load data:
    # -------------------------------------

    # -- try load (returns NULL if not found)
    items <- kfiles::read_data(file = file,
                               path = path$data,
                               colClasses = col.classes,
                               create = CREATE_FILE)

    # -- store objects
    r[[r_items]] <- reactiveVal(items)
    colClasses(col.classes)
    filter_cols(filter.cols)

    # -- init triggers
    r[[trigger_add]] <- reactiveVal(NULL)



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
        colnames(value) <- str_to_title(colnames(value))

      } else value <- NULL

      # return
      value

    })


    # -------------------------------------
    # Outputs:
    # -------------------------------------

    # Raw view for admin
    output$raw_item_table <- renderDT(r[[r_items]](),
                                 rownames = FALSE,
                                 options = list(lengthMenu = c(5, 10, 15), pageLength = 5, dom = "ltp"),
                                 selection = list(mode = 'single', target = "row", selected = NULL))

    # Masked view for admin
    output$view_item_table <- renderDT(view_items(),
                                       rownames = FALSE,
                                       options = list(lengthMenu = c(5, 10, 15), pageLength = 5, dom = "ltp"),
                                       selection = list(mode = 'single', target = "row", selected = NULL))


    # Masked view for user
    # TODO: add user view (add function params for renderDT...)


    # -------------------------------------
    # Auto save:
    # -------------------------------------

    # save items
    observeEvent(r[[r_items]](), {

      kfiles::write_data(data = r[[r_items]](),
                         file = file,
                         path = path$data)

    }, ignoreInit = TRUE)


    # save colClasses
    observeEvent(colClasses(), {

      cat("[SAVE] colClasses \n")
      saveRDS(colClasses(), file = file.path(path$resource, paste0(id, "_colClasses.rds")))

    }, ignoreInit = TRUE)


    # save filter_cols
    observeEvent(filter_cols(), {

      cat("[SAVE] filter_cols \n")
      saveRDS(filter_cols(), file = file.path(path$resource, paste0(id, "_filterCols.rds")))

    }, ignoreInit = TRUE, ignoreNULL = FALSE)


    # -------------------------------------
    # Action buttons:
    # -------------------------------------

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
                           choices = COL_CLASSES_LIST,
                           selected = NULL,
                           options = list(create = FALSE,
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

      updateSelectizeInput(session = session,
                           inputId = "add_col_type",
                           choices = COL_CLASSES_LIST,
                           selected = TEMPLATE_COLS[TEMPLATE_COLS$name == input$add_col_name, ]$type)})



    # -- BTN create_data
    observeEvent(input$create_data, {

      cat("[BTN] Create data \n")

      # create items
      tmp_colClasses <- c("id" = "numeric")
      items <- createItems(path$data, file, tmp_colClasses)

      # store items and colClasses
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
      items <- addColumn(r[[r_items]](), name = input$add_col_name, type = input$add_col_type, colClasses = colClasses(), fill = NA)
      r[[r_items]](items)

      # update & store colClasses
      tmp_colClasses <- colClasses()
      tmp_colClasses[input$add_col_name] <- input$add_col_type
      colClasses(tmp_colClasses)

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
    # User UI:
    # -------------------------------------

    # new item
    observeEvent(input$btn_new_item, {

      showModal(getModalDialog(item = NULL, update = FALSE, colClasses = colClasses()))

    })


  })
}

