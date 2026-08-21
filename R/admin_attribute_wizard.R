

admin_attribute_wizard <- function(config, item, callback, session = getDefaultReactiveDomain()){

  # -- get inputs
  input <- session$input
  output <- session$output

  # ----------------------------------------------------------------------------
  # Step.1 name
  # ----------------------------------------------------------------------------

  wizard_step_1 <- function(){

    # -- init UI
    insertUI(selector = "#input-container",
             where = "afterBegin",
             ui = div(id = "input-content",
                      textInput(inputId = "attribute_name", label = "Name")))

    # -- validate
    obs <- observeEvent(input$attribute_name, {

      #-- init
      is_valid <- TRUE

      # -- rules
      # empty
      if(input$attribute_name == ""){
        is_valid <- FALSE
        output$w_validation <- renderUI(
          p(class = "text-danger", icon("circle-xmark"), "A name is required."))}

      # duplicate
      if(input$attribute_name %in% config_attributes(config, item)){
        is_valid <- FALSE
        output$w_validation <- renderUI(
          p(class = "text-danger", icon("circle-xmark"), "This name already exists."))}

      # funny char
      if(grepl("(?![_.-])[[:punct:]]", input$attribute_name, perl = TRUE)){
        is_valid <- FALSE
        output$w_validation <- renderUI(
          p(class = "text-danger", icon("circle-xmark"), "Only underscore, dash and dot are allowed."))}

      if(is_valid){
        output$w_validation <- renderUI(p(class = "text-success", icon("circle-check"), "The name is valid."))
        output$w_actions <- renderUI(actionButton(inputId = "w_next", label = "Next", icon = icon("circle-chevron-right")))
      } else
        output$w_actions <- renderUI(NULL)

    })

    # -- store step
    session$userData$kitems$wizard$step <- list(id = 1, listeners = obs)

  }


  # ----------------------------------------------------------------------------
  # Step.2 type
  # ----------------------------------------------------------------------------

  wizard_step_2 <- function(){

    # -- init UI
    insertUI(selector = "#input-container",
             where = "afterBegin",
             ui = div(id = "input-content",
                      selectInput(inputId = "attribute_type",
                                  label = "Name",
                                  choices = c("integer", "character"))))

    # -- no validation is required
    output$w_actions <- renderUI(
      actionButton(inputId = "w_next", label = "Next", icon = icon("circle-chevron-right")))

    # -- store step
    session$userData$kitems$wizard$step <- list(id = 2)

  }


  # ----------------------------------------------------------------------------
  # Step.3 hide / skip
  # ----------------------------------------------------------------------------

  wizard_step_3 <- function(){

    # -- init UI
    insertUI(selector = "#input-container",
             where = "afterBegin",
             ui = div(id = "input-content",
                      p("Should the attribute column be hidden in the item table?"),
                      checkboxInput(inputId = "attribute_hide", label = "Hide"),
                      p("Should the attribute be skipped in the item form?", br(),
                        "If so, its value will be computed based on defaults."),
                      checkboxInput(inputId = "attribute_skip", label = "Skip")))

    # -- no validation is required
    output$w_actions <- renderUI(
      actionButton(inputId = "w_next", label = "Next", icon = icon("circle-chevron-right")))

    # -- store step
    session$userData$kitems$wizard$step <- list(id = 3)

  }


  # ----------------------------------------------------------------------------
  # Step.4 confirmation
  # ----------------------------------------------------------------------------

  wizard_step_4 <- function(){

    # -- init UI
    insertUI(selector = "#input-container",
             where = "afterBegin",
             ui = div(id = "input-content",
                      p("Attibute summary, please check the parameters:"),
                      tags$ul(
                        tags$li("Name: ", input$attribute_name),
                        tags$li("Type: ", input$attribute_type)),
                      p("Additional behaviors, the attribute will be:"),
                      tags$ul(
                        tags$li(ifelse(input$attribute_hide, "Hidden", "Displayed"), "in the item table."),
                        if(input$attribute_skip)
                          tags$li("Skipped in the item form."))))

    # -- no validation is required
    output$w_actions <- renderUI(
      actionButton(inputId = "w_confirm", label = "Create attribute", icon = icon("circle-chevron-right")))

    # -- store step
    session$userData$kitems$wizard$step <- list(id = 4)

  }


  # ----------------------------------------------------------------------------
  # Cleanup
  # ----------------------------------------------------------------------------

  cleanup <- function(wizard = FALSE, session = getDefaultReactiveDomain()){

    # -- cleanup modal UI
    output$w_validation <- renderUI(NULL)
    output$w_actions <- renderUI(NULL)
    removeUI(selector = "#input-content", immediate = TRUE)

    # -- helper: destroy observers
    helper <- function(obs){
      if(!is.null(obs)){
        if(is.list(obs))
          lapply(obs, function(x) x$destroy())
        else
          obs$destroy()}}

    # -- destroy step listeners
    helper(session$userData$kitems$wizard$step$listeners)

    # -- destroy wizard listeners
    if(wizard)
      helper(session$userData$kitems$wizard$listeners)

  }


  # ----------------------------------------------------------------------------
  # Next step
  # ----------------------------------------------------------------------------

  obs_next <- observeEvent(input$w_next, {

    message("w_next")

    # -- cleanup step
    cleanup()

    # -- launch next step
    get(paste0("wizard_step_", session$userData$kitems$wizard$step$id + 1))()

  }, ignoreInit = TRUE)

  # -- store
  session$userData$kitems$wizard$listeners <- obs_next


  # ----------------------------------------------------------------------------
  # Cancel wizard
  # ----------------------------------------------------------------------------

  observeEvent(input$w_cancel, {

    message("w_cancel")

    # -- cleanup UI
    removeModal()

    # -- cleanup wizard
    cleanup(wizard = TRUE)

    # -- cleanup userData
    session$userData$kitems[['wizard']] <- NULL

  }, ignoreInit = TRUE, once = TRUE)


  # ----------------------------------------------------------------------------
  # Final confirmation
  # ----------------------------------------------------------------------------

  obs_confirm <- observeEvent(input$w_confirm, {

    message("w_confirm")

    # -- cleanup UI
    removeModal()

    # -- cleanup wizard
    cleanup(wizard = TRUE)

    # -- cleanup userData
    session$userData$kitems[['wizard']] <- NULL

    # -- pass inputs to callback
    callback(
      list(name = input$attribute_name,
           type = input$attribute_type,
           hide = input$attribute_hide,
           skip = input$attribute_skip))

  }, ignoreInit = TRUE, once = TRUE)

  # -- store
  session$userData$kitems$wizard$listeners <- c(session$userData$kitems$wizard$listeners, obs_confirm)


  # ----------------------------------------------------------------------------
  # Launch wizard
  # ----------------------------------------------------------------------------

  # -- init
  output$w_actions <- renderUI(NULL)
  showModal(
    admin_attribute_modal())

  # -- start
  wizard_step_1()

}
