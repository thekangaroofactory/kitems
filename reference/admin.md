# Kitems Admin Console

Launches the administration console (Shiny App)

## Usage

``` r
admin(path = getwd())
```

## Arguments

- path:

  the path where to find item folder(s)

## Details

The app will scan the path to detect sub folders that are expected to be
item folders named after the id used to create them.

It will build the ui from this list.

## Examples

``` r
if (FALSE) { # \dontrun{
admin()
} # }
```
