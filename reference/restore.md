# Restore Files

Restores the data model & items files.

## Usage

``` r
restore(id, path, type = "items")
```

## Arguments

- id:

  the id used to create the data model.

- path:

  the path to the data model.

- type:

  the type of file to backup. `items` (default) or `dm`.

## Examples

``` r
if (FALSE) { # \dontrun{
restore(id = "mydata", path = "path/to/mydata", type = "items")
restore(id = "mydata", path = "path/to/mydata", type = "dm")
} # }
```
