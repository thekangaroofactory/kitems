# Build Attribute Input

Build Attribute Input

## Usage

``` r
attribute_input(colClass, value = NULL, ns)
```

## Arguments

- colClass:

  a length-one named vector. `names(colClass)` is the name of the
  attribute, and `colClass` is the type (class) of the attribute.

- value:

  the value used to initialize the input

- ns:

  the module namespace function reference

## Value

an input based on colClass

## Examples

``` r
if (FALSE) { # \dontrun{
attribute_input(colClass = c(name = "character"), ns)
attribute_input(colClass = c(total = "numeric"), value = 10, ns)
} # }
```
