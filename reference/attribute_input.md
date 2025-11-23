# Attribute Input

Build input for an attribute

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

  the namespace function reference

## Value

An input that can be added to the UI definition.

## Examples

``` r
if (FALSE) { # \dontrun{
# -- namespace
ns <- shiny::NS("my_data")

# -- create inputs
attribute_input(colClass = c(name = "character"), ns)
attribute_input(colClass = c(total = "numeric"), value = 10, ns)
} # }
```
