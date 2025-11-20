# Build Attribute Shortcuts

Build Attribute Shortcuts

## Usage

``` r
attribute_shortcut(colClass, suggestions, ns)
```

## Arguments

- colClass:

  a length-one named vector. `names(colClass)` is the name of the
  attribute, and `colClass` is the type (class) of the attribute.

- suggestions:

  a list of suggestions, output of
  [attribute_suggestion](https://thekangaroofactory.github.io/kitems/reference/attribute_suggestion.md)

- ns:

  the module namespace function reference

## Value

a list of actionLink objects

The return value is the output of
[lapply](https://rdrr.io/r/base/lapply.html) applying
[actionLink](https://rdrr.io/pkg/shiny/man/actionButton.html) over
`suggestions`

The actionLink has an `onclick` property that will trigger
`input$shortcut_trigger` (`ns(shortcut_trigger)`) Its value is of the
form `[ns]-[attribute]_[value]` Basically, applying
`tail(unlist(strsplit(input$shortcut_trigger, split = "-")), 1)` will
access attribute_value

Note that for POSIXct attribute, the shortcut_trigger input will not
carry the timezone information. Clicking on the corresponding actionLink
will only trigger date & time inputs update.

## See also

[`attribute_suggestion()`](https://thekangaroofactory.github.io/kitems/reference/attribute_suggestion.md)
[`item_form()`](https://thekangaroofactory.github.io/kitems/reference/item_form.md)

## Examples

``` r
if (FALSE) { # \dontrun{
attribute_shortcut(colClass = c(name = "character"),
suggestions = list(mango = 25, banana = 12, lemon = 10),
ns = session$ns)
} # }
```
