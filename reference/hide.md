# Display Behavior Grammar

A set of verbs to manipulate the display of an attribute.

## Usage

``` r
hide(config, item = get_context(), ...)

display(config, item = get_context(), ...)

hidden(config, item = get_context())

displayed(config, item = get_context())
```

## Arguments

- config:

  the config list.

- item:

  the name (id) of the item group.

- ...:

  the name of the attribute(s) to manipulate.

## Value

a list (setters) or a character vector (getters).

## Details

`hide()` and `display()` are setter functions to tune attribute's
behavior. `hidden()` and `displayed()` are getter functions to quickly
access the attributes to hide or display in the item table.

When `item` is set in the parent frame, then the attribute can be
skipped in the function call.

## See also

[`amend()`](https://thekangaroofactory.github.io/kitems/reference/amend.md),
[`parent.frame()`](https://rdrr.io/r/base/sys.parent.html)

## Examples

``` r
if (FALSE) { # \dontrun{
# hide attribute
config <- design(project = "test",
item = "foo") |>
extend(item = "foo", attribute = c(name = "date", type = "Date")) |>
hide(item = "foo", "date")

# allow skipping argument in following calls
item <- "foo"

# hidden attributes
config |> hidden()

# display attribute
config |> display("date")

# displayed attributes
config |> displayed()
} # }
```
