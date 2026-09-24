# Extend Item

Add specific attribute(s) with fine tuning.

## Usage

``` r
extend(config, item = get_context(), ...)
```

## Arguments

- config:

  the config object.

- item:

  the name (id) of the item group.

- ...:

  one or several attribute instructions.

## Value

a list.

## Details

This function is a wrapper around
[`design()`](https://thekangaroofactory.github.io/kitems/reference/design.md)
to provide a comprehensive layered syntax.

It only understands the `attribute` instruction inside `...`:
`attribute = c(name = "note", type = "character")` Anything else will be
filtered.

When `item` is set in the parent frame, then the parameter can be
skipped in the function call.

## See also

[`design()`](https://thekangaroofactory.github.io/kitems/reference/design.md),
[`parent.frame()`](https://rdrr.io/r/base/sys.parent.html)

## Examples

``` r
if (FALSE) { # \dontrun{
# create config
config <- design(project = "test",
        item = "foo")

# set item (to skip it in following calls)
item <- "foo"

# extend
config |>
  extend(attribute = c(name = "date", type = "Date", default = "Sys.Date()"))

# is same as
config <- design(project = "test",
        item = "foo",
        attribute = c(name = "date", type = "Date", default = "Sys.Date()"))
} # }
```
