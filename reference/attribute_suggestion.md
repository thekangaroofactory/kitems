# Attribute Suggestions

Attribute Suggestions

## Usage

``` r
attribute_suggestion(values, type = class(values), n = 3, floor = 10)
```

## Arguments

- values:

  a vector of values, most probably corresponding to one of the item's
  data frame columns.

- type:

  an optional character vector, the type (class) of values. If not
  provided, `class(values)` will be used.

- n:

  the desired number of suggestions. This applies only on character,
  factor, numeric & integer types.

- floor:

  a numeric value to indicate a floor frequency. This applies only for
  numeric & integer types (see details).

## Value

A list of suggestions that depends on the `type` of values:

- character, factor: the most frequent values ;
  `list(value1 = frequency, value_2, = frequency)`

- numeric, integer: the most frequent values ;
  `list(value1 = frequency, value_2, = frequency)`, or a standard list ;
  `list(min, max, mean, median)`

- logical: the frequency for both values ;
  `list(true = frequency, false = frequency)`

- Date, POSIXct: a standard list ; `list(min, max)`

## Details

For numeric & integer values, the default strategy is to compute the `n`
most frequent occurrences. If no occurrence reaches the `floor` level (%
of all items), then a standard list is returned.

## Examples

``` r
# -- define values
foo <- c(rep("banana", 5), rep("mango", 3), rep("orange", 2))

attribute_suggestion(values = foo, type = "character")
#> $banana
#> [1] 50
#> 
#> $mango
#> [1] 30
#> 
#> $orange
#> [1] 20
#> 
```
