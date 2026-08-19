

card_attribute <- function(attribute, hide = NULL, skip = NULL, update = NULL){

  # -- return
  bslib::card(

    # -- attribute name
    bslib::card_header(class = "d-flex justify-content-between",
                       attribute$name,
                       div(
                         if(attribute$name %in% hide)
                           bslib::tooltip(icon("eye-slash"), "The attribute is not displayed"),
                         if(attribute$name %in% skip)
                           bslib::tooltip(icon("bolt-lightning"), "The attribute is skipped"),
                         if(attribute$name %in% update)
                           icon("rotate"))),

    # -- content
    bslib::card_body(

      # -- mandatory
      p("type:", attribute$type),

      # -- optional
      if("default" %in% names(attribute))
        p("default value:", attribute$default)

    ),

    bslib::card_footer(class = "d-flex justify-content-end",
      icon("gear"),
      icon("arrows-left-right"),
      icon("trash", class = "dz")
    )

  )

}
