% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/properties.R
\name{tabular_environment}
\alias{tabular_environment}
\alias{tabular_environment<-}
\alias{set_tabular_environment}
\title{Tabular environment}
\usage{
tabular_environment(ht)
tabular_environment(ht) <- value
set_tabular_environment(ht, value)
}
\arguments{
\item{ht}{A huxtable.}

\item{value}{A length-one character vector. Set to \code{NA} to reset to the default, which is
\code{NA}.}
}
\value{
For \code{tabular_environment}, the \code{tabular_environment} property.
For \code{set_tabular_environment}, the modified huxtable.
}
\description{
Functions to get or set the table-level \emph{tabular environment} property of a huxtable.
}
\details{
No features are guaranteed to work if you set this to a non-default value. Use at your own risk!
}
\examples{

orig <- tabular_environment(jams)
tabular_environment(jams) <-  "longtable"
tabular_environment(jams)

tabular_environment(jams) <- orig
}
