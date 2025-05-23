% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dm_delete_preview.R
\name{dm_delete_preview}
\alias{dm_delete_preview}
\title{Data model delete preview modal}
\usage{
dm_delete_preview(
  hasItems = FALSE,
  dm.file = FALSE,
  item.file = FALSE,
  autosave = FALSE,
  id = NULL,
  ns
)
}
\arguments{
\item{hasItems}{a logical if there are items (items data frame not NULL)}

\item{dm.file}{a logical if data model file exists}

\item{item.file}{a logical if item file exists}

\item{autosave}{a logical if autosave is ON}

\item{id}{the id if the module}

\item{ns}{the namespace function to be used}
}
\value{
a modalDialog
}
\description{
Data model delete preview modal
}
\examples{
\dontrun{
dm_delete_preview(hasItems = TRUE,
dm.file = TRUE,
item.file = TRUE,
autosave = TRUE,
id = "mydata",
ns = ns)
}

}
