# Check Config

Check YAML config structure & content

## Usage

``` r
config_check(config)
```

## Arguments

- config:

  a config list

## Value

a list

## Details

The function will return a list of problems or an empty list. Each
problem has a type (note, warning or error) and a message. Errors are
most likely to prevent the package from working properly. Warnings may
affect the behavior. Notes are here for information but should not
affect the behavior.

## Examples

``` r
if (FALSE) { # \dontrun{
config_check(config)
} # }
```
