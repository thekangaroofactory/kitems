# Validate Value(s)

Validate values and turn them into item(s).

## Usage

``` r
validate(values, data.model, items = NULL, update = FALSE)
```

## Arguments

- values:

  a list of named values.

- data.model:

  the data.frame of the data model (see details).

- items:

  an optional data.frame of the items (see details).

- update:

  whether the id attribute should be checked or not (default `FALSE`).

## Value

A data.frame.

## Details

This function does not accept the data.model element of the config list
as an input. It should be turned into a data.frame first, using
[`yaml_to_dm()`](https://thekangaroofactory.github.io/kitems/reference/yaml_to_dm.md).

`data.model` should contain the following columns: "name", "type",
"default", "class.arg", "values".

In case the data.model values column contains instruction that require
data-masking, `items` will be used as a context to evaluate those
instructions.

## Examples

``` r
if (FALSE) { # \dontrun{
# create config
config <- design(project = "test", item = "foo") |>
extend(item = "foo",
attribute = list(name = "name", type = "character"),
attribute = list(name = "quantity", type = "numeric"))

# values
values <- list(name = c("Banana", "Mango"), quantity = c(1, 12))

# call function
validate(values, data.model = yaml_to_dm(config, "name", "type", "default", "class.arg", "values"))
} # }
```
