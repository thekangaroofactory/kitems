# Generate Dynamic menuItem

Generate Dynamic menuItem

## Usage

``` r
dynamic_sidebar(names)
```

## Arguments

- names:

  a list of the data model names

## Value

a sidebarMenu menuItem object with one menuSubItem per data model

## Examples

``` r
if (FALSE) { # \dontrun{
dynamic_sidebar(names = list("data", "data2"))
} # }
```
