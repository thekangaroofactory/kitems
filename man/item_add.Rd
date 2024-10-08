% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/item_add.R
\name{item_add}
\alias{item_add}
\title{Add item}
\usage{
item_add(items, item, name = NULL)
}
\arguments{
\item{items}{the reference! of the reactive value carrying the items}

\item{item}{an item data.frame to be added}

\item{name}{an optional character string to display along with the notification (basically the name of the item)}
}
\description{
Add item
}
\examples{
\dontrun{
item_add(items = myitems, item = mynewitem, name = "myitem")
}
}
