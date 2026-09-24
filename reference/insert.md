# Insert Item(s)

Insert Item(s)

## Usage

``` r
insert(values, items)
```

## Arguments

- values:

  a data.frame of item(s) to insert.

- items:

  a data.frame of items where to insert.

## Value

a data.frame.

## Details

The function is mostly a wrapper around
[`dplyr::bind_rows()`](https://dplyr.tidyverse.org/reference/bind_rows.html)
function.

It does check for potential duplicates among the 'id' column. If so, the
operation will be aborted as there is no way to know how to fix the
duplicated id(s).

## Examples

``` r
if (FALSE) { # \dontrun{
insert(values, items)} # }
```
