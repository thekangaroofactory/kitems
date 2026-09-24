# Attribute Values

Compute attribute values with data-masking support.

## Usage

``` r
compute(x, data = NULL)
```

## Arguments

- x:

  a character string of the expression to evaluate.

- data:

  an optional data.frame to use for tidy evaluation of `x`.

## Value

a vector of values.

## Examples

``` r
if (FALSE) { # \dontrun{
# baseline
compute(x = "suggest(1, 2)")

# with data masking
compute(x = "suggest(min(value))", data = data.frame(value = c(12, 10)))
} # }
```
