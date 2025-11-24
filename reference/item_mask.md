# Item Mask

Apply a mask on the data.frame of the items.

## Usage

``` r
item_mask(data.model, items)
```

## Arguments

- data.model:

  a data.frame of the data model.

- items:

  a data.frame of the items.

## Value

A data.frame of the items with applied masks.

## Details

Two masks are applied:

- the data model masks (attributes with display = `TRUE` are kept)

- a default mask (replace . and \_ by a space in the attribute names,
  plus capitalize first letter)

## Examples

``` r
if (FALSE) { # \dontrun{
item_mask(data.model = "mydatamodel", items = "myitems")
} # }
```
