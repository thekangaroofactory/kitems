

# -- function definition
#' Title
#'
#' @param id
#' @param r
#' @param file
#' @param path
#' @param col.classes
#' @param filter.cols
#' @param create
#' @param autosave
#'
#' @return
#' @export
#'
#' @examples


# ------------------------------------------------------------------------------
# Shiny module server logic
# ------------------------------------------------------------------------------

kitemsManager_Server <- function(id, r, file, path, col.classes = NA, filter.cols = NULL, create = TRUE, autosave = TRUE) {
  moduleServer(id, function(input, output, session) {

    # --------------------------------------------------------------------------
    # Declare config parameters:
    # --------------------------------------------------------------------------

    # -- Build log pattern
    MODULE <- paste0("[", id, "]")

    # -- Object types
    OBJECT_CLASS <- c("NA", "NULL",
                      "numeric", "integer", "complex", "logical", "character", "raw",
                      "double", "factor", "Date", "POSIXct", "POSIXlt")

    # -- Column name / type  template
    TEMPLATE_COLS <- data.frame(name = c("date",
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


    # -- Build object names from module id (to access outside module)
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
    filter_cols <- reactiveVal(NULL)

    # -- Declare reactive objects (for external use)
    r[[trigger_add]] <- reactiveVal(NULL)


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

    # -- Store into communication objects
    r[[r_items]] <- reactiveVal(items)


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
                                           options = list(lengthMenu = c(5, 10, 15), pageLength = 5, dom = "t", scrollX = TRUE),
                                           selection = list(mode = 'single', target = "row", selected = NULL))


    # Masked view for user
    # TODO: add user view (add function params for renderDT...)







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
                         choices = OBJECT_CLASS,
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

      # -- check if input in template
      if(tolower(input$add_col_name) %in% TEMPLATE_COLS$name)

        updateSelectizeInput(session = session,
                             inputId = "add_col_type",
                             choices = OBJECT_CLASS,
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

