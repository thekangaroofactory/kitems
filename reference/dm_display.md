# Data Model Display

A getter/setter function to manage data model display.

## Usage

``` r
dm_display(data.model, set = NULL)
```

## Arguments

- data.model:

  a data.frame containing the data model.

- set:

  an optional character vector with the name of the attributes to set as
  hidden.

## Value

Either the list of attributes that are hidden or an updated data model
if `set` is not `NULL`

## Examples

``` r
if (FALSE) { # \dontrun{
dm_display(data.model = mydatamodel, set = c("id", "internal"))
} # }
```
