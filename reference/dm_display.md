# Data Model Display

Data Model Display

## Usage

``` r
dm_display(data.model, set = NULL)
```

## Arguments

- data.model:

  a data.frame containing the data model

- set:

  an optional character vector with the name of the attributes to set as
  hidden

## Value

either the list of attributes that are hidden or an updated data model
if set is not NULL

## Details

If set is NULL, then the data model passed as data.model is returned

## Examples

``` r
if (FALSE) { # \dontrun{
dm_display(data.model = mydatamodel, set = c("id", "internal"))
} # }
```
