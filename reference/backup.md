# Backup Files

Backup config, data model or items files.

## Usage

``` r
backup(
  type = c("config", "items", "dm"),
  id = NULL,
  max = 1,
  path = Sys.getenv("R_KITEMS_PATH")
)
```

## Arguments

- type:

  the type of file to backup (see details).

- id:

  the id of the item or data model.

- max:

  an integer (default = 1) to indicate how many backup files are
  allowed.

- path:

  optional, the path to the data.

## Details

`type` accepts the following values:

- "config" (the default)

- "items"

- "dm"

"dm" is kept to enable data.model backup before migration to the YAML
config.

`id` will be ignored if `type = "config"`

The recommended way to define the `path` argument is to set the
`R_KITEMS_PATH` environment variable.

Backup file will be named as *\_kitems_YYYY-MM-DD.yml*,
*id_data_model_YYYY-MM-DD.rds* or *id_items_YYYY-MM-DD.csv* If same file
already exists, it will be overwritten.

## Examples

``` r
if (FALSE) { # \dontrun{
# backup config
backup()
} # }
```
