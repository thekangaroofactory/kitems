# Backup Data Model & Items Files

Backup Data Model & Items Files

## Usage

``` r
backup(id, path, type = "items", max = NULL)
```

## Arguments

- id:

  the kitems id used to create the data model

- path:

  the path to the data model

- type:

  the type of file to backup. `items` (default) or `dm`

- max:

  an integer to indicate how many backup files are allowed

## Details

Backup file will be named as *id_data_model_YYYY-MM-DD.rds* If same file
already exists, it will be overwritten.

If the number of backup files exceeds `max` then the oldest will be
deleted. Whenever `max = NULL` (default), it will be replaced by 1

## Examples

``` r
if (FALSE) { # \dontrun{
backup(id = "mydata", path = "path/to/my/data", max = 2)
} # }
```
