# Attribute Input

Build input for an attribute.

## Usage

``` r
attribute_input(
  name,
  type,
  value = NULL,
  choices = NULL,
  create = FALSE,
  session = getDefaultReactiveDomain()
)
```

## Arguments

- name:

  the name of the attribute.

- type:

  the type of the attribute.

- value:

  the value to be used to initialize the input.

- choices:

  a list of values to select from (see details).

- create:

  a logical (default = `FALSE`) if user is allowed to create values (see
  details).

- session:

  optional, the shiny session object.

## Value

An input that can be added to the UI definition.

## Details

By default (`choices = NULL`), the function will return an input driven
by the type of the attribute. When `choices` are provided, it will be
replaced by a selectizeInput. User will be allowed to create additional
values depending on `create` (otherwise ignored).

## Examples

``` r
if (FALSE) { # \dontrun{
# -- create inputs
attribute_input(name = "total", type = "numeric", value = 10)
} # }
```
