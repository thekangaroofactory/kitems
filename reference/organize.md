# Sort Items Grammar

Set or get sorting order.

## Usage

``` r
organize(config, item = get_context(), sort)

organized(config, item = get_context())
```

## Arguments

- config:

  the config list.

- item:

  the name (id) of the item group.

- sort:

  a character string to set the order (see details).

## Value

`organize` returns a list and `organized` returns a character string

## Details

The `organize` function accepts a character string for `sort` because it
is primarily intended to deal with the Admin Console (which returns a
character string from the user input).

Setting `sort = NULL` will reset the item sorting!

Ranking depends on the position of the attribute. Wrap attribute name by
"desc()" to set descending order.

When `item` is set in the parent frame, then the attribute can be
skipped in the function call.

## See also

[`parent.frame()`](https://rdrr.io/r/base/sys.parent.html)

## Examples

``` r
if (FALSE) { # \dontrun{
organize(config, item = "foo", sort = "date, desc(total)")
organize(config, item = "foo", sort = NULL)
} # }
```
