# Introduction to kitems

The goal of *kitems* is to provide a framework to manage data frame
*items* and a set of tools to implement it within R Shiny web
applications.

## Motivations xxx

When working on a R Shiny project that performs operations based on
tabular data, whether it is for data analysis or data visualization, the
first milestone in the project is to enable standard data processing.

Say the purpose of the project is to build a task manager and deliver a
dashboard to follow its KPIs.  
It will require to write code to implement the baseline of the project:

- a data frame to manage the tasks objects  
  (with columns corresponding to the different attributes of a task:
  date, description, owner…)

- a data table view to display the tasks to the users

- inputs to allow data filtering  
  (maybe focus on the tasks of the current year)

- buttons to perform standard operations like create a new task, update
  or delete existing ones

- forms to allow user to create or update a task

- functions to manage those operations in the back end  
  (check inputs before creating a new task, ask for a confirmation
  before another is deleted)

- functions to ensure data persistence, quality and management in
  general

Now say that another project is to build a dashboard to follow fruit
stock.  
A data frame of fruit objects is needed, a table view, buttons &
functions to perform standard operations…

In many cases, it involves to write code that allows to handle the same
set of operations but for different objects, which makes this code hard
to reuse in another project.

The purpose of *kitems* is to wrap those standard operations into a
package that is not dependent on the type of *item* - *something that is
part of a list or group of things* - to manage.

So that developers can focus on the specific capabilities of their
project.
