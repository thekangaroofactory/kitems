% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dm_default.R
\name{dm_default}
\alias{dm_default}
\title{Compute default value for an attribute}
\usage{
dm_default(data.model, name)
}
\arguments{
\item{data.model}{a data.frame containing the data model}

\item{name}{a character string with the attribute name}
}
\value{
the default value or computed output of the default function
}
\description{
Compute default value for an attribute
}
\examples{
\dontrun{
value <- dm_default(data.model = mydatamodel, name = "date")
}
}
