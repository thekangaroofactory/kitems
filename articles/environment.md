# Environment

This article is here to keep all environment considerations in a single
place.

## Path

The YAML project config file as well as the item files are stored in
specific folders linked to the project.

- at the path level for the YAML config file
- in dedicated folders for the items files

The item folders are named after the item `id` that is also used to
start the corresponding module server instance.

The path is defined in the `R_KITEMS_PATH` environment variable:

``` r

Sys.setenv(R_KITEMS_PATH = "path/to/the/project/data")
```

From version
[0.8.0](https://thekangaroofactory.github.io/kitems/news/index.html#kitems-v080),
this is the standard way to set the location where the data should be
found or created.  
When this environment variable is not set, it will be detected and
messages will be displayed accordingly.

> **Important**
>
> For backward compatibility purpose, the `path` argument of the module
> server function has been kept, with default value pointing to the
> `R_KITEMS_PATH` environment variable.  
> When the argument gets an explicit value, a message will be displayed
> to indicate this should now be done through the environment variable.

## Debug

For debugging purpose, the package implements traces through outputs to
the console.

But because printing to the console has serious impact on the overall
app performance, it has been decided to wrap the trace mechanism into a
function that only outputs the log when it is activated.

To set the trace level, you may export the `R_KITEMS_DEBUG` environment
variable

- 0 = no traces (except specific messages, warnings or errors)
- 1 = verbose (standard traces, usually the main steps)
- 2 = more verbose (detailed traces)

``` r

Sys.setenv(R_KITEMS_DEBUG = 1)
```

Another way to activate it is to use the
[`ktools::trace_level()`](https://thekangaroofactory.github.io/ktools/reference/trace_level.html)
function:

``` r

# set the traces
ktools::trace_level(1)

# unset the traces
ktools::trace_level(0)

# check
ktools::trace_level()
```
