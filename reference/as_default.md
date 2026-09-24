# Turn Item Into Default Value(s)

Turn Item Into Default Value(s)

## Usage

``` r
as_default(item, data.model)
```

## Arguments

- item:

  the data.frame of the item to use as a reference.

- data.model:

  the data.frame of the data.model (see details).

## Value

a data.frame to pass to form() function.

## Details

This function does not accept the data.model element of the config list
as an input. It should be turned into a data.frame first, using
[`yaml_to_dm()`](https://thekangaroofactory.github.io/kitems/reference/yaml_to_dm.md).

`data.model` should contain the following columns: "name", "type",
"default", "values".

`item` and `data.model` must have same structure. That means the names
of the attributes in the data model are expected to match with the names
of the columns in item.

## Examples
