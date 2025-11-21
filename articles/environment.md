# Environment

This article is here to keep all environment considerations in a single
place.

## Path

Both data model & item files are stored in a specific folder dedicated
to given instance instance of the module server.

- the folder is named after the `id` of the module

- it is located under the path given to the `path` argument

``` r
kitems::kitems(id = "mydata", path = "./data")
```

For this reason, unless there is a single instance of the module, it is
not recommended to name any of the `id` with same name as the last
folder of the provided path. It may result in files being stored at
different levels.

Examples:

``` r
kitems::kitems(id = "data", path = "./path/to/data")
```

Files will be stored in “./path/to/data”

``` r
kitems::kitems(id = "data_1", path = "./path/to/data")
```

Files will be stored in “./path/to/data/data_1”

## Debug

For debugging purpose, the package implements many traces through
outputs to the console.

But because printing to the console has serious impact on the overall
app performance, it has been decided to wrap the trace mechanism into a
function that only outputs the log when it is activated.

To set the trace level, you need to use the
[`ktools::trace_level()`](https://rdrr.io/pkg/ktools/man/trace_level.html)
function.
