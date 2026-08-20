

admin_attribute_wizard <- function(config, item, session = getDefaultReactiveDomain()){

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
    session$userData$kitems$wizard <- list(step = 1,
                                           listeners = obs)

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
    session$userData$kitems$wizard <- list(step = 2)

  }


  # ----------------------------------------------------------------------------
  # Step.3 hide / skip / update
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
                      checkboxInput(inputId = "attribute_skip", label = "Skip"),
                      p("Since skipped, should the attribute be computed again when an item is updated?"),
                      checkboxInput(inputId = "attribute_update", label = "Update")))

    # -- no validation is required
    output$w_actions <- renderUI(
      actionButton(inputId = "w_next", label = "Next", icon = icon("circle-chevron-right")))

    # -- store step
    session$userData$kitems$wizard <- list(step = 3)

  }


  # ----------------------------------------------------------------------------
  # Launch wizard
  # ----------------------------------------------------------------------------

  # -- init
  output$w_actions <- renderUI(NULL)
  showModal(
    admin_attribute_modal())

  # -- start
  wizard_step_1()


  # ----------------------------------------------------------------------------
  # Next step
  # ----------------------------------------------------------------------------

  observeEvent(input$w_next, {

    # -- cleanup modal
    output$w_validation <- renderUI(NULL)
    output$w_actions <- renderUI(NULL)
    removeUI(selector = "#input-content", immediate = TRUE)

    # -- destroy observers
    obs <- session$userData$kitems$wizard$listeners
    if(!is.null(obs)){
      if(is.list(obs))
        lapply(obs, function(x) x$destroy())
      else
        obs$destroy()}

    # -- launch next step
    get(paste0("wizard_step_", session$userData$kitems$wizard$step + 1))()

  })


  # ----------------------------------------------------------------------------
  # Final confirmation
  # ----------------------------------------------------------------------------

  observeEvent(input$w_confirm, {

    # step.1
    input$attribute_name

    # step.2
    input$attribute_type

    # step.3
    input$attribute_hide
    input$attribute_skip
    input$attribute_update

  })

}
