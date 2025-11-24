# Update Item(s)

Update Item(s)

## Usage

``` r
rows_update(items, values, data.model)
```

## Arguments

- items:

  a data.frame of the items.

- values:

  a list of named values.

- data.model:

  a data.frame of the data.model.

## Value

a data.frame of the items

## Details

values is a named list. The names are used to check the corresponding
values vs the data.model (class, default values if the provided one is
not valid). The elements in the list must have either length one or same
length as the id element.

When an element has length one but the id has several values, all items
corresponding to these ids will be updated with same value. To do so,
values will be turned into a data.frame using as.data.frame ; for this
reason, it's strongly advised to wrap the call into tryCatch as this may
fail.

## Examples

``` r
if (FALSE) { # \dontrun{
rows_update(items, values, data.model)} # }
```
