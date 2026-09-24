# Config List To Table

Turn a config list into a data.frame.

## Usage

``` r
yaml_to_dm(config, ..., item = get_context())
```

## Arguments

- config:

  the config list (see details).

- ...:

  the columns to include in the output.

- item:

  the name (id) of the item group.

## Value

a data.frame

## Details

The function is used as a bridge between the config list structure and
the expected data.frame input argument for some functions.

It also helps to keep / select the desired columns. Pass the column
names (quoted or unquoted) to `...`. Note that if the function is used
inside a package (kitems does), then the column names should be quoted
or R-CMD Check will throw a note about 'no visible binding for global
variable' since the column names are not declared as symbol in the
environment.

By default, `config` is the global project config list. `item` is
required in this case unless it is already set in the parent frame.

In case the item level config list is provided, it should be up to the
data.model's level. Make sure to explicitly set `ìtem = NULL` if it is
set in the parent frame.

## Examples

``` r
if (FALSE) { # \dontrun{
# get data.model with name and default
yaml_to_dm(config, name, default, item = "foo")
} # }
```
