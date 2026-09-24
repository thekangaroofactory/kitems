# Amend Attribute

Update specific parameter(s) of specific attribute(s).

## Usage

``` r
amend(config, item = get_context(), ...)
```

## Arguments

- config:

  the config list.

- item:

  the name (id) of the item group.

- ...:

  one or several attribute instructions.

## Value

a list

## Details

The function only understands `attribute` instruction. It can handle
multiple instructions in `...`.

Note that it is forbidden to update:

- the id attribute (any parameter),

- the name and/or type of an attribute.

When `item` is set in the parent frame, then the attribute can be
skipped in the function call.

## See also

[`design()`](https://thekangaroofactory.github.io/kitems/reference/design.md),
[`parent.frame()`](https://rdrr.io/r/base/sys.parent.html)

## Examples

``` r
if (FALSE) { # \dontrun{
# create baseline
config <- design(project = "test",
                 item = "foo") |>
  extend(item = "foo",
         attribute = c(name = "total", type = "integer"))

# skip item argument (in the following calls)
item <- "foo"

# single instruction
config |>
  amend(attribute = c(name = "total", default = 12))
config |>
  amend(attribute = c(name = "total", values = "suggest(12)"))

# multiple instructions
config |>
  amend(attribute = c(name = "total", values = "suggest(12)"),
        attribute = c(name = "total", default = "0"))
} # }
```
