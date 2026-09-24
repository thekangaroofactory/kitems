# Data Model To YAML

Convert data model to YAML configuration file.

## Usage

``` r
dm_to_yaml(dm)
```

## Arguments

- dm:

  a data.frame of the data model

## Value

a list.

## Details

The input data model should have its version = "0.8.0" otherwise an
error will be raised. Use
[`dm_migrate()`](https://thekangaroofactory.github.io/kitems/reference/dm_migrate.md)
first if needed.

## Examples

``` r
if (FALSE) { # \dontrun{
dm_to_yaml(dm)
} # }
```
