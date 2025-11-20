# Restore Data Model & Items Files

Restore Data Model & Items Files

## Usage

``` r
restore(id, path, type = "items")
```

## Arguments

- id:

  the kitems id used to create the data model

- path:

  the path to the data model

- type:

  the type of file to backup. `items` (default) or `dm`

## Examples

``` r
if (FALSE) { # \dontrun{
restore(id = "mydata", path = "path/to/mydata", type = "items")
restore(id = "mydata", path = "path/to/mydata", type = "dm")
} # }
```
