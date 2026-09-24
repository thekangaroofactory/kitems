# Input Values

Extract the list of values from the input.

## Usage

``` r
extract(input, colClasses)
```

## Arguments

- input:

  the input object from the shiny module.

- colClasses:

  a named vector of classes, defining the data model.

## Value

a named list.

## Details

The output list will contain as many entries as the `colClasses` named
vector. In case some names have no corresponding item in the input
parameter, they will get `NULL` as value in the output list.

## Examples

``` r
if (FALSE) { # \dontrun{
values <- extract(input, colClasses = c("date" = "Date", "text" = "character"))
} # }
```
