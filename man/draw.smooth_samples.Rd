% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/draw-methods.R
\name{draw.smooth_samples}
\alias{draw.smooth_samples}
\title{Plot posterior smooths}
\usage{
\method{draw}{smooth_samples}(
  object,
  select = NULL,
  xlab = NULL,
  ylab = NULL,
  title = NULL,
  subtitle = NULL,
  caption = NULL,
  alpha = 1,
  colour = "black",
  scales = c("free", "fixed"),
  align = "hv",
  axis = "lrtb",
  rug = TRUE,
  partial_match = FALSE,
  ...
)
}
\arguments{
\item{object}{a fitted GAM, the result of a call to \code{\link[mgcv:gam]{mgcv::gam()}}.}

\item{select}{character, logical, or numeric; which smooths to plot. If
\code{NULL}, the default, then all model smooths are drawn. Numeric \code{select}
indexes the smooths in the order they are specified in the formula and
stored in \code{object}. Character \code{select} matches the labels for smooths
as shown for example in the output from \code{summary(object)}. Logical
\code{select} operates as per numeric \code{select} in the order that smooths are
stored.}

\item{xlab}{character or expression; the label for the x axis. If not
supplied, a suitable label will be generated from \code{object}.}

\item{ylab}{character or expression; the label for the y axis. If not
supplied, a suitable label will be generated from \code{object}.}

\item{title}{character or expression; the title for the plot. See
\code{\link[ggplot2:labs]{ggplot2::labs()}}.}

\item{subtitle}{character or expression; the subtitle for the plot. See
\code{\link[ggplot2:labs]{ggplot2::labs()}}.}

\item{caption}{character or expression; the plot caption. See
\code{\link[ggplot2:labs]{ggplot2::labs()}}.}

\item{alpha}{numeric; alpha transparency for confidence or simultaneous
interval.}

\item{colour}{The colour to use to draw the posterior smooths. Passed to
\code{\link[ggplot2:geom_line]{ggplot2::geom_line()}} as argument \code{colour}.}

\item{scales}{character; should all univariate smooths be plotted with the
same y-axis scale? The default, \code{scales = "fixed"}, ensures this is done.
If \code{scales = "free"} each univariate smooth has its own y-axis scale.
Currently does not affect the y-axis scale of plots of the parametric
terms.}

\item{align}{characer; see argument \code{align} in \code{cowplot::plot_grid()}.
Defaults to \code{"hv"} so that plots are nicely aligned.}

\item{axis}{characer; see argument \code{axis} in \code{cowplot::plot_grid()}.
Defaults to \code{"lrtb"} so that plots are nicely aligned.}

\item{rug}{logical; draw a rug plot at the botom of each plot?}

\item{partial_match}{logical; should smooths be selected by partial matches
with \code{select}? If \code{TRUE}, \code{select} can only be a single string to match
against.}

\item{...}{arguments to be passed to \code{\link[cowplot:plot_grid]{cowplot::plot_grid()}}.}
}
\description{
Plot posterior smooths
}
\examples{
load_mgcv()
\dontshow{set.seed(1)}
dat1 <- gamSim(1, n = 400, dist = "normal", scale = 2, verbose = FALSE)
## a single smooth GAM
m1 <- gam(y ~ s(x0) + s(x1) + s(x2) + s(x3), data = dat1, method = "REML")
## posterior smooths from m1
sm1 <- smooth_samples(m1, n = 15, seed = 23478)
## plot
draw(sm1, alpha = 0.7)

\dontshow{set.seed(1)}
dat2 <- gamSim(4, verbose = FALSE)
## a multi-smooth GAM with a factor-by smooth
m2 <- gam(y ~ fac + s(x2, by = fac) + s(x0), data = dat2, method = "REML")
## posterior smooths from m1
sm2 <- smooth_samples(m2, n = 15, seed = 23478)
## plot, this time selecting only the factor-by smooth
draw(sm2, select = "s(x2)", partial_match = TRUE, alpha = 0.7)
}
\author{
Gavin L. Simpson
}
