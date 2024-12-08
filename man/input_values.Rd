% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/input_values.R
\name{input_values}
\alias{input_values}
\title{Build list of input values}
\usage{
input_values(input, colClasses)
}
\arguments{
\item{input}{the input object from the shiny module}

\item{colClasses}{a named vector of classes, defining the data model}
}
\value{
a list of values
}
\description{
Build list of input values
}
\details{
the output list will contain as many entries as the colClasses named vector.
In case some names have no corresponding item in the input parameter, they will get NULL as value
in the output list.
}
\examples{
\dontrun{
values <- input_values(input, colClasses = c("date" = "Date", "text" = "character"))
}
}
