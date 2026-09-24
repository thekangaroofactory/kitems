# Skip Behavior Grammar

A set of verbs to manipulate the skipped attribute(s) of an item.

## Usage

``` r
skip(config, item = get_context(), ...)

include(config, item = get_context(), ...)

skipped(config, item = get_context())

included(config, item = get_context())
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

`skip()` and `include()` are setter functions that allow to add or
remove attributes from the skipped ones. `skipped()` and `included()`
are getter functions to quickly access the attributes that are skipped
or included in the item form.

In a scenario where items are created programmatically, `included()` may
be used to determine what values can be sent to the trigger.

When `item` is set in the parent frame, then the attribute can be
skipped in the function call.

## See also

[`amend()`](https://thekangaroofactory.github.io/kitems/reference/amend.md),
[`parent.frame()`](https://rdrr.io/r/base/sys.parent.html)

## Examples

``` r
if (FALSE) { # \dontrun{
# skip attribute
config <- design(project = "test",
item = "foo") |>
extend(item = "foo", attribute = c(name = "date", type = "Date")) |>
skip(item = "foo", "date")

# get skipped attributes
config |> skipped(item = "foo")

# include attribute
config |> include(item = "foo", "date")

# get included attributes
config |> included(item = "foo")
} # }
```
