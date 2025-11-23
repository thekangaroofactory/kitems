# Introduction to kitems

The goal of *kitems* is to provide a framework to manage data frame
*items* and a set of tools to implement it within R Shiny web
applications.

## Motivations

When working on a R Shiny project that performs operations based on
tabular data, whether it is for data analysis or data visualization, the
first milestone in the project is to enable standard data processing.

Say the purpose of the project is to build a task manager and deliver a
dashboard to follow its KPIs.

Before being able to work on the dashboard itself, it will require to
write code to implement the baseline of the project:

- a data frame to manage the tasks attributes (date, description,
  owner…)

- a table view to display the tasks to the users

- inputs to allow data filtering (ex. current year)

- buttons to perform standard operations like create a task, update or
  delete existing ones

- forms to capture user inputs

- functions to manage those operations in the background

- functions to ensure data persistence, quality and management /
  governance

Now say that another project is to build a dashboard to follow fruit
stocks.  
A data frame of fruit objects is needed, a table view, buttons &
functions to perform standard operations…

In many cases, it involves to write code that allows to handle the
**same** set of operations but for different objects, which makes this
code hard to reuse in another project.

> **Note**
>
> The purpose of *kitems* is to wrap those standard operations into a
> package that is not dependent on the type of *item* – *something that
> is part of a list or group of things* – to manage.

So that developers can focus on the specific capabilities of their
project.

## Shiny module

The package is deeply correlated with the development of Shiny
applications, so that it has been quite obvious that the best approach
would be to deliver a module.

To start the module server, just call the
[`kitems()`](https://thekangaroofactory.github.io/kitems/reference/kitems.md)
function from the app server:

``` r
mydata <- kitems::kitems(id = "mydata", path = "./")
```

Components to interact with the module server can be integrated inside
the UI of your app.  
For example, the
[`filtered_view_widget()`](https://thekangaroofactory.github.io/kitems/reference/filtered_view_widget.md)
function will output the item table:

``` r
kitems::filtered_view_widget(id = "mydata")
```

See the
[`vignette("shiny-module")`](https://thekangaroofactory.github.io/kitems/articles/shiny-module.md)
article to get more information about the module.

## Learning path

Because the package is not ‘just’ a set of functions, it has some
concepts that have been defined either as starting points or after deep
explorations & convergence.

As it may be confusing where to start, the order of the articles is a
proposal of a learning path to guide you through the documentation.

See articles’
[index](https://thekangaroofactory.github.io/kitems/articles/index.md)
to follow this path.
