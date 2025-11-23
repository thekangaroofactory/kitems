# Communication

## Introduction

Basically, communication **to** the module server relies on the server
function arguments and UI-Server interactions, while communication
**from** the module server (to its parent) relies on the server function
return value(s).

> **Note**
>
> The framework communication strategy has been implemented based on the
> research & exploration work captured in this eBook: [Communication
> between shiny
> modules](https://thekangaroofactory.github.io/communication-between-shiny-modules/).
>
> It is expected that the package will be used in this context.

## Arguments

Among the arguments that can be passed to the server function to tune
its internal behaviors are the reactive parameters named `trigger` &
`filter` that behave like event managers.

Whenever they receive a reactive object **reference** as input value,
the module will take a dependency on it and declare a listener to react
to specific events for the module to execute dedicated actions on the
items.

- `trigger` is used to pass create / update / delete actions

- `filter` is used to set / unset filters

Reactive arguments are a key feature for the module to be used within
more advanced
[implementations](https://thekangaroofactory.github.io/kitems/articles/implementations.md).

## Return value(s)

The module server function returns a list of elements that are
accessible outside the module.

Among these elements are reactive object’s **references** that are used
as communication objects. You can take a dependency / listen to those
objects to trigger further actions in your app.

A typical example is a plot that will be updated as soon as the items
are modified.

``` r
# -- call the module server
mydata <- kitems::kitems(id = "my_data", path = "./data")

# -- plot
output$plot <- renderPlot({
  
  # -- do something here
  
}) |> bindEvent(mydata$items())
```

## Considerations

The magic with passing references is that the value itself is not copied
or duplicated.[¹](#fn1)

All the reactive objects of the return value are created with the
[`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html)
function, so that it is not possible to update them from outside of the
module server function.

It makes the framework more robust against data model or *item*
corruption.

It also allows to use the exported functions of the package from outside
of the module server, which provides more flexible implementation
options.

## Useful links

- Scenarios & use cases –
  [implementations](https://thekangaroofactory.github.io/kitems/articles/implementations.md)

- Module server function –
  [`kitems()`](https://thekangaroofactory.github.io/kitems/reference/kitems.md)

- Arguments & return value(s) –
  [shiny-module](https://thekangaroofactory.github.io/kitems/articles/shiny-module.md)

- Item workflows –
  [workflows](https://thekangaroofactory.github.io/kitems/articles/workflows.md)

------------------------------------------------------------------------

1.  See *Advanced R*
    <https://adv-r.hadley.nz/names-values.html#names-values>
