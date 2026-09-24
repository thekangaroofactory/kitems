# Reveal Items

Apply data model display mask on the items.

## Usage

``` r
reveal(items, config, item = get_context())
```

## Arguments

- items:

  the data.frame of the items.

- config:

  the config list.

- item:

  the name (id) of the item group.

## Value

A data.frame.

## Details

The data model display mask is defined at the data.model level. use
[`hide()`](https://thekangaroofactory.github.io/kitems/reference/hide.md)
or
[`display()`](https://thekangaroofactory.github.io/kitems/reference/hide.md)
to tune it.

When `item` is set in the parent frame, then the attribute can be
skipped in the function call.

## See also

\[hide()\]\[display()\]\[parent.frame()\]

## Examples

``` r
if (FALSE) { # \dontrun{
# assuming config has been declared and
# items is the data.frame of the items
item <- "foo"
items |> reveal(config)
} # }
```
