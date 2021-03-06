% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/draw-methods.R
\name{draw.gam}
\alias{draw.gam}
\title{Plot estimated smooths from a fitted GAM}
\usage{
\method{draw}{gam}(
  object,
  parametric = NULL,
  select = NULL,
  residuals = FALSE,
  scales = c("free", "fixed"),
  align = "hv",
  axis = "lrtb",
  ci_level = 0.95,
  n = 100,
  unconditional = FALSE,
  overall_uncertainty = TRUE,
  dist = 0.1,
  rug = TRUE,
  contour = TRUE,
  contour_col = "black",
  n_contour = NULL,
  partial_match = FALSE,
  ...
)
}
\arguments{
\item{object}{a fitted GAM, the result of a call to \code{\link[mgcv:gam]{mgcv::gam()}}.}

\item{parametric}{logical; plot parametric terms also? Default is \code{TRUE},
only if \code{select} is \code{NULL}. If \code{select} is used, \code{parametric} is set to
\code{FALSE} unless the user specifically sets \code{parametric = TRUE}.}

\item{select}{character, logical, or numeric; which smooths to plot. If
\code{NULL}, the default, then all model smooths are drawn. Numeric \code{select}
indexes the smooths in the order they are specified in the formula and
stored in \code{object}. Character \code{select} matches the labels for smooths
as shown for example in the output from \code{summary(object)}. Logical
\code{select} operates as per numeric \code{select} in the order that smooths are
stored.}

\item{residuals}{logical; should partial residuals for a smooth be drawn?
Ignored for anything but a simple univariate smooth.}

\item{scales}{character; should all univariate smooths be plotted with the
same y-axis scale? The default, \code{scales = "fixed"}, ensures this is done.
If \code{scales = "free"} each univariate smooth has its own y-axis scale.
Currently does not affect the y-axis scale of plots of the parametric
terms.}

\item{align}{characer; see argument \code{align} in \code{cowplot::plot_grid()}.
Defaults to \code{"hv"} so that plots are nicely aligned.}

\item{axis}{characer; see argument \code{axis} in \code{cowplot::plot_grid()}.
Defaults to \code{"lrtb"} so that plots are nicely aligned.}

\item{ci_level}{numeric between 0 and 1; the coverage of credible interval.}

\item{n}{numeric; the number of points over the range of the covariate at
which to evaluate the smooth.}

\item{unconditional}{logical; should confidence intervals include the
uncertainty due to smoothness selection? If \code{TRUE}, the corrected Bayesian
covariance matrix will be used.}

\item{overall_uncertainty}{logical; should the uncertainty in the model
constant term be included in the standard error of the evaluate values of
the smooth?}

\item{dist}{numeric; if greater than 0, this is used to determine when
a location is too far from data to be plotted when plotting 2-D smooths.
The data are scaled into the unit square before deciding what to exclude,
and \code{dist} is a distance within the unit square. See
\code{\link[mgcv:exclude.too.far]{mgcv::exclude.too.far()}} for further details.}

\item{rug}{logical; draw a rug plot at the botom of each plot?}

\item{contour}{logical; should contours be draw on the plot using
\code{\link[ggplot2:geom_contour]{ggplot2::geom_contour()}}.}

\item{contour_col}{colour specification for contour lines.}

\item{n_contour}{numeric; the number of contour bins. Will result in
\code{n_contour - 1} contour lines being drawn. See \code{\link[ggplot2:geom_contour]{ggplot2::geom_contour()}}.}

\item{partial_match}{logical; should smooths be selected by partial matches
with \code{select}? If \code{TRUE}, \code{select} can only be a single string to match
against.}

\item{...}{arguments passed to \code{cowplot::plot_grid()}. Any arguments to
\code{plot_grid()} may be supplied, except for: \code{plotlist} and \code{align}.}
}
\value{
The object returned is created by \code{\link[cowplot:plot_grid]{cowplot::plot_grid()}}.
}
\description{
Plots estimated smooths from a fitted GAM model in a similar way to
\code{mgcv::plot.gam()} but instead of using base graphics, \code{\link[ggplot2:ggplot]{ggplot2::ggplot()}}
is used instead.
}
\note{
Internally, plots of each smooth are created using \code{\link[ggplot2:ggplot]{ggplot2::ggplot()}}
and composed into a single plot using \code{\link[cowplot:plot_grid]{cowplot::plot_grid()}}. As a result,
it is not possible to use \code{+} to add to the plots in the way one might
typically work with \code{ggplot()} plots.
}
\examples{
load_mgcv()

\dontshow{set.seed(2)}
dat <- gamSim(1, n = 400, dist = "normal", scale = 2)
m1 <- gam(y ~ s(x0) + s(x1) + s(x2) + s(x3), data = dat, method = "REML")

draw(m1)

## can add partial residuals
draw(m1, residuals = TRUE)

\dontshow{set.seed(2)}
dat <- gamSim(2, n = 1000, dist = "normal", scale = 1)
m2 <- gam(y ~ s(x, z, k = 40), data = dat$data, method = "REML")
draw(m2, contour = FALSE)

## change the number of contours drawn
draw(m2, n_contour = 5)
}
\author{
Gavin L. Simpson
}
