# Call Conversion Functions

Helper function to call the class conversion functions with arguments

## Usage

``` r
convert(x, class, class.arg = NULL)
```

## Arguments

- x:

  the object to be converted

- class:

  the target class

- class.arg:

  a character string with the arguments (see details)

## Value

the converted object

## Details

`class.arg` must be like "list(arg1 = 12, arg2 = 'foo')"

## Examples

``` r
if (FALSE) { # \dontrun{
convert("2025-09-10T13:16:55Z", "POSIXct", "list(format = '%Y-%m-%dT%H:%M:%S')")
} # }
```
