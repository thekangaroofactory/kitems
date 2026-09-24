# Sort Items

Sort Items

## Usage

``` r
adjust(items, config, item = get_context())
```

## Arguments

- items:

  a data.frame of the items.

- config:

  the config list.

- item:

  the name (id) of the item group.

## Value

a data.frame.

## Details

The sorting order is given by the sort entry in the config list.

When `item` is set in the parent frame, then the attribute can be
skipped in the function call.

## See also

[organize()](https://rdrr.io/r/base/sys.parent.html)

## Examples

``` r
if (FALSE) { # \dontrun{
items |> adjust(config, item = "foo")
} # }
```
