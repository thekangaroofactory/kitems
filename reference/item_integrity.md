# Items Integrity

Check items integrity vs the data model.

## Usage

``` r
item_integrity(items, data.model)
```

## Arguments

- items:

  a data.frame of the items.

- data.model:

  a data.frame of the data model.

## Value

A data.frame of the items, with corrected attribute types.

## Details

The function checks if the class of the attributes in items matches with
the one in the data model. If not, it will coerce the values of the
corresponding column to the data model class.

## Examples

``` r
if (FALSE) { # \dontrun{
items <- item_integrity(items, data.model)
} # }
```
