# Build YAML Config

Design the project configuration.

## Usage

``` r
design(...)
```

## Arguments

- ...:

  one or several instruction(s) to execute (see details).

## Value

a list.

## Details

`design` is the core function / verb when it comes to building
configuration.

The function understands the following instructions passed to `...`:

- `project` to create a config from scratch

- `item` to add an item group to the project config

- `attribute` to add an attribute to a given item group.

An instruction is always formed of a key (`project`, `item` or
`attribute`) and a value. The value can either be a length-one character
string or a named character vector. The `project = "test"` instruction
is used in almost all function documentation examples to init a project
config. `item = "foo"` or
`item = c(id = "foo", description = "not bar")` are used to add an item
group to the project.

`attribute = c(item = "foo", name = "value", type = "integer")` creates
an attribute named 'value' that will accept integers inside the item
group 'foo'.

Multiple instructions are supported as recursion is implemented (the
function can call itself to execute each instruction and merge the
outputs).

As the package grammar is designed for a layered approach, `design` only
covers attribute creation without fine tuning. This means it creates
attribute(s) with name & type only.

- use `extend` to create an attribute with fine tuning.

- use `hide`, `display`, `skip`, `include` & `refresh` to set specific
  attribute behaviors.

In addition to the named instructions, a single unnamed argument is
accepted among `...` to support piping from the config object (see
examples). If multiple unnamed objects are passed, an error will be
thrown.

## Examples

``` r
if (FALSE) { # \dontrun{
# create project config from scratch
config <- design(project = "foo")

# add (single) item group
config |> design(item = "foo")
config |> design(item = c(id = "foo", description = "x"))

# add (multiple) item groups
config |> design(item = "foo",
                 item = "bar")
config |> design(item = c(id = "foo", description = "x"),
                 item = c(id = "bar", description = "z"))
config |> design(item = c(id = "foo", description = "x"),
                 item = "bar")
# add (single) attribute to item group
config |> design(item = "foo",
                 attribute = c(item = "foo", name = "value", type = "integer"))
# add (multiple) attributes to item group
config |> design(item = "foo",
                 attribute = c(item = "foo", name = "value", type = "integer"),
                 attribute = c(item = "foo", name = "comment", type = "character"))
# if instruction is not understood
design(dream = "draw me a sheep")
} # }
```
