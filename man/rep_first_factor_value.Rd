% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utililties.R
\name{rep_first_factor_value}
\alias{rep_first_factor_value}
\title{Repeat the first level of a factor n times}
\usage{
rep_first_factor_value(f, n)
}
\arguments{
\item{f}{a factor}

\item{n}{numeric; the number of times to repeat the first level of \code{f}}
}
\value{
A factor of length \code{n} with the levels of \code{f}, but whose elements
are all the first level of \code{f}.
}
\description{
Function to repeat the first level of a factor n times and
return this vector as a factor with the original levels intact
}
