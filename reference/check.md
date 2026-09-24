# Check Integrity

Wrapper function to either check the YAML config or items integrity.

## Usage

``` r
check(...)
```

## Arguments

- ...:

  the object(s) to check (see details)

## Value

a list

## Details

The function is smart enough to detect what is passed to `...`. To check
the items, it is necessary to also pass the corresponding id in the
config (see examples).

## Examples

``` r
if (FALSE) { # \dontrun{
# check config (list)
config <- design(project = "test")
check(config)

# check items (data.frame)
check(items, config, id = "foo")
} # }
```
