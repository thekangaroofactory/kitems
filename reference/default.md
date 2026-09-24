# Default Value(s)

Compute default value(s).

## Usage

``` r
default(data.model)
```

## Arguments

- data.model:

  the data.frame of the data model.

## Value

A data.frame.

## Details

This function does not accept the data.model element of the config list
as an input. It should be turned into a data.frame first, using
[`yaml_to_dm()`](https://thekangaroofactory.github.io/kitems/reference/yaml_to_dm.md).

`data.model` should contain the following columns: "name", "type",
"default" and "values".

## Examples
