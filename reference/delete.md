# Delete Item(s)

Delete Item(s)

## Usage

``` r
delete(items, id)
```

## Arguments

- items:

  the data.frame of the items.

- id:

  a vector of id(s) for the item(s) to delete.

## Value

a data.frame.

## Details

The function will drop unmatched id(s).

## Examples

``` r
if (FALSE) { # \dontrun{
delete(items = myitems, id = 123456789)
} # }
```
