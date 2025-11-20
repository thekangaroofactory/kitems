# Truthy Value

Inspired by Shiny::isTruthy, the purpose here is to determine if a value
is considered as valid to be an attribute value (or if it will need to
be replaced by the attribute defaults)

## Usage

``` r
is_truthy(x)
```

## Arguments

- x:

  an object to test

## Value

a logical

## Examples

``` r
is_truthy(12)
#> [1] TRUE
```
