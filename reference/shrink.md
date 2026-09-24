# Shrink Config

Shrink Config

## Usage

``` r
shrink(config, ...)
```

## Arguments

- config:

  the config list.

- ...:

  one or several item or attribute instruction.

## Value

a list.

## Details

Drop an item or an attribute from the config.

The function understands the following instructions:

- `item = foo`

- `attribute = c(item = "foo", name = "total")` See the examples for
  more details.

It supports multiple instructions.

Note that it is forbidden to delete the 'id' attribute of an item.

## Examples

``` r
if (FALSE) { # \dontrun{
# build baseline
config <- design(project = "test",
item = "foo") |>
  extend(item = "foo",
         attribute = c(name = "total", type = "integer"))

# drop item
config |>
  shrink(item = "foo")

# drop attribute
config |>
  shrink(attribute = c(item = "foo", name = "total"))

# multiple instructions
config |>
  shrink(attribute = c(item = "foo", name = "total"),
         item = "foo")
} # }
```
