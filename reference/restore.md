# Restore Files

Restore config, data model or items files.

## Usage

``` r
restore(
  type = c("config", "items", "dm"),
  id = NULL,
  path = Sys.getenv("R_KITEMS_PATH")
)
```

## Arguments

- type:

  the type of file to restore (see details).

- id:

  the id for data.model & items.

- path:

  optional, the path to the data.

## Value

a logical (see [`file.copy()`](https://rdrr.io/r/base/files.html))

## Details

`type` accepts the following values:

- "config" (the default)

- "items"

- "dm"

When "config" is used, `id` is ignored. "dm" is kept for compatibility
purpose.

The recommended way to define the `path` argument is to set the
`R_KITEMS_PATH` environment variable.

In case several backup files exist, the newest one will be restored.

## Examples

``` r
if (FALSE) { # \dontrun{
restore()
restore(type = "items", id = "foo")
} # }
```
