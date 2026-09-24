# Refresh Behavior Grammar

A set of verbs to manipulate the refreshed attribute(s) of an item.

## Usage

``` r
refresh(config, item = get_context(), ...)

freeze(config, item = get_context(), ...)

refreshed(config, item = get_context())

frozen(config, item = get_context())
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

`refresh()` and `freeze()` are setter functions that allow to add or
remove attributes from the refreshed ones. `refreshed()` and `frozen()`
are getter functions to quickly access the skipped attributes that are
refreshed or not during an item update.

Trying to refresh an attribute that is not skipped will be ignored
*without* a warning.

When `item` is set in the parent frame, then the attribute can be
skipped in the function call.

## See also

[`amend()`](https://thekangaroofactory.github.io/kitems/reference/amend.md),
[`parent.frame()`](https://rdrr.io/r/base/sys.parent.html)

## Examples

``` r
if (FALSE) { # \dontrun{
# refresh attribute
config <- design(project = "test",
item = "foo") |>
extend(item = "foo", attribute = c(name = "date", type = "Date")) |>
skip(item = "foo", "date") |>
refresh(item = "foo", "date")

# refreshed attributes
config |> refreshed(item = "foo")

# freeze attribute
config |> freeze(item = "foo", "date")

# frozen attributes
config |> frozen(item = "foo")
} # }
```
