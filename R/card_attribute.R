

card_attribute <- function(attribute){

  # -- return
  bslib::card(

    # -- attribute name
    bslib::card_header(attribute$name,
                       bslib::tooltip(icon("eye-slash"), "The attribute is not displayed"),
                       icon("bolt-lightning"),
                       icon("rotate")),

    # -- content
    bslib::card_body(

      # -- mandatory
      p("type:", attribute$type),

      # -- optional
      if("default" %in% names(attribute))
        p("default value:", attribute$default)

    ),

    bslib::card_footer(
      icon("gear"),
      icon("arrows-left-right"),
      icon("trash", class = "dz")
    )

  )

}
