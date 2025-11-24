# Search Items

A simple wrapper around
[filter](https://dplyr.tidyverse.org/reference/filter.html) function.

## Usage

``` r
item_search(items, pattern)
```

## Arguments

- items:

  a data.frame of items.

- pattern:

  the search pattern.

## Value

A filtered data.frame.

## Details

The function is not intended to perform any smart or advanced search.  
It provides basic search across all except `id` attributes.

Basically it returns `filter(items, if_any(-(id), ~ grepl(pattern, .)))`

## Examples

``` r
if (FALSE) { # \dontrun{
item_search(items = mydata$items(), pattern = "Banana")
item_search(items = mydata$items(), pattern = 25)
} # }
```
