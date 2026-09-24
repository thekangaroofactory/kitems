# Default Item Context

Helper function to provide a contextual default value.

## Usage

``` r
get_context()
```

## Value

a character value or NULL

## Details

Since the project YAML config has been introduced (v0.8.0), all core
functions require to provide the name (id) of the item group to
manipulate.

At the grammar level functions, this argument needs to be collected to
pass it's value to the core level functions.

When used inside the module server (one instance is dedicated to a
specific item group) or any custom code applied to a single item group,
it would be tidious to repeat this argument with the same value for each
call.

By setting item = get_context(), the argument will get it's value from
the environment in which the function was called.

## Examples

``` r
# baseline
config <- design(project = "test", item = "foo")

# instead of
config |> extend(item = "foo", attribute = c(name = "total", type = "integer"))
#> $version
#> [1] "0.8.0"
#> 
#> $project
#> [1] "test"
#> 
#> $items
#> $items[[1]]
#> $items[[1]]$id
#> [1] "foo"
#> 
#> $items[[1]]$source
#> $items[[1]]$source$type
#> [1] "file"
#> 
#> $items[[1]]$source$path
#> [1] "/foo"
#> 
#> $items[[1]]$source$filename
#> [1] "foo_items.csv"
#> 
#> 
#> $items[[1]]$data.model
#> $items[[1]]$data.model$attributes
#> $items[[1]]$data.model$attributes[[1]]
#> $items[[1]]$data.model$attributes[[1]]$name
#> [1] "id"
#> 
#> $items[[1]]$data.model$attributes[[1]]$type
#> [1] "numeric"
#> 
#> $items[[1]]$data.model$attributes[[1]]$default
#> [1] "ktools::uuid()"
#> 
#> 
#> $items[[1]]$data.model$attributes[[2]]
#> $items[[1]]$data.model$attributes[[2]]$name
#> [1] "total"
#> 
#> $items[[1]]$data.model$attributes[[2]]$type
#> [1] "integer"
#> 
#> 
#> 
#> $items[[1]]$data.model$skip
#> [1] "id"
#> 
#> $items[[1]]$data.model$hide
#> [1] "id"
#> 
#> 
#> 
#> 

# one can do
item <- "foo"
config |> extend(attribute = c(name = "total", type = "integer"))
#> $version
#> [1] "0.8.0"
#> 
#> $project
#> [1] "test"
#> 
#> $items
#> $items[[1]]
#> $items[[1]]$id
#> [1] "foo"
#> 
#> $items[[1]]$source
#> $items[[1]]$source$type
#> [1] "file"
#> 
#> $items[[1]]$source$path
#> [1] "/foo"
#> 
#> $items[[1]]$source$filename
#> [1] "foo_items.csv"
#> 
#> 
#> $items[[1]]$data.model
#> $items[[1]]$data.model$attributes
#> $items[[1]]$data.model$attributes[[1]]
#> $items[[1]]$data.model$attributes[[1]]$name
#> [1] "id"
#> 
#> $items[[1]]$data.model$attributes[[1]]$type
#> [1] "numeric"
#> 
#> $items[[1]]$data.model$attributes[[1]]$default
#> [1] "ktools::uuid()"
#> 
#> 
#> $items[[1]]$data.model$attributes[[2]]
#> $items[[1]]$data.model$attributes[[2]]$name
#> [1] "total"
#> 
#> $items[[1]]$data.model$attributes[[2]]$type
#> [1] "integer"
#> 
#> 
#> 
#> $items[[1]]$data.model$skip
#> [1] "id"
#> 
#> $items[[1]]$data.model$hide
#> [1] "id"
#> 
#> 
#> 
#> 
```
