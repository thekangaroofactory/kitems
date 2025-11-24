# Input Values

Build a list of values from the input.

## Usage

``` r
item_input_values(input, colClasses)
```

## Arguments

- input:

  the input object from the shiny module.

- colClasses:

  a named vector of classes, defining the data model.

## Value

a named list of values.

## Details

the output list will contain as many entries as the `colClasses` named
vector. In case some names have no corresponding item in the input
parameter, they will get `NULL` as value in the output list.

## Examples

``` r
if (FALSE) { # \dontrun{
values <- item_input_values(input, colClasses = c("date" = "Date", "text" = "character"))
} # }
```
