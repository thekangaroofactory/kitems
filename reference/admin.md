# Admin Console

Launches the administration console.

## Usage

``` r
admin()
```

## Details

The Admin Console is a standalone Shiny web app delivered along with the
package to administrate the items of the project.

It will check the `R_KITEMS_PATH` environment variable and look for the
YAML config file in the provided path.

## Examples

``` r
if (FALSE) { # \dontrun{
# set environment (where to find the _kitems.yml)
Sys.setenv("R_KITEMS_PATH" = "D:/data")

# launch the Admin Console
admin()
} # }
```
