

admin_item_layout <- function(x){

  # -- return
  bslib::nav_panel(title = x$id,
                   icon = icon(name = "box"),

                   bslib::layout_sidebar(
                     border = FALSE,

                     sidebar = bslib::sidebar(
                       position = "right",
                       width = 300,
                       open = TRUE,

                       h3("Source"),
                       p("Type:", x$source$type, br(),
                         if(x$source$type == "file")
                           paste("path:", x$source$path)),

                       h3("Skipped"),
                       p("No input will be generated for those attributes when creating / updating items."),
                       span(class = "text-warning", paste(x$data.model$skip, collapse = "|")),

                       h3("Display"),
                       p("Attributes that won't be displayed in the item table."),
                       span(class = "text-warning", paste(x$data.model$hide, collapse = "|")),

                       h3("Danger zone"),
                       bslib::input_switch(id = "dz", label = "Allow")

                     ),

                     h1(class = "mb-3", length(x$data.model$attributes), "attributes"),
                     bslib::layout_column_wrap(
                       !!!lapply(x$data.model$attributes, card_attribute),
                       actionButton(inputId = "create", "+"))))

}

admin_item_card <- function(name, description = NULL){

  # -- return
  div(class="bslib-grid-item bslib-gap-spacing html-fill-container",
      bslib::card(
        bslib::card_header(name),
        p(id = paste0(name, "_description"), "Description:", description),

        # -- allow update
        if(is.null(description))
          actionLink(inputId = paste0(name, "_update_description"),
                     label = "Set description",
                     icon = icon("circle-arrow-right"),
                     onclick = ktools::onclick_event(target = "update_description")),

        # -- nav link
        actionLink(inputId = paste0(name, "_select_tab"),
                   label = "Switch tab",
                   icon = icon("circle-arrow-right"),
                   onclick = ktools::onclick_event(target = "select_tab"))))

}

