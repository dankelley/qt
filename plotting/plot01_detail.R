library(oce)
library(RSQLite)
equilibriumVaporPressure <- function(t, p=1000) {
    ## Buck formula
    ## https://en.wikipedia.org/wiki/Relative_humidity#Measurement
    (1.0007 + 3.46e-6*p) * 6.1121*exp(17.502*t/(240.97+t))
}
#' Calculate dew point with Magnus formula
#'
#' The formulae are taken from David Bolton 1980 in Mon. Weather Rev.
#' downloaded from https://www.rsmas.miami.edu/users/pzuidema/Bolton.pdf
#' on July 19, 2016. Bolton's equation numbers are given in square brackets.
#'
#' @author Dan Kelley
#'
#' @param t temperature in degC
#' @param q relative humidity in percent
#' @param a coefficient in Magnus formula; the default is from the wikipedia page
#' @param b coefficient in Magnus formula; the default is from the wikipedia page
#' @param c coefficient in Magnus formula; the default is from the wikipedia page
#' @param d coefficient in Magnus formula; the default is from the wikipedia page
dewPoint <- function(t, q, a=6.112, b=18.678, c=257.14, d=234.5)
{
    gammam <- log((q/100) * exp((b-t/d)*(t/(c+t))))
    c * gammam / (b - gammam)
}

humidex <- function(t, q)
{
    tdew <- dewPoint(t, q) + 273.16
    t + 0.5555*(6.11*exp(5417.7530*(1/273.15-1/tdew)) - 10)
}


m <- dbDriver("SQLite")
con <- dbConnect(m, dbname="/Users/kelley/qt/database/qt.db")
observations <- dbGetQuery(con, "select time,t,q from observations")
## FIXME: check timezone
time <- as.POSIXlt(numberAsPOSIXct(observations$time, tz="America/Halifax"))
t <- observations$t
n <- length(t)
q <- observations$q
timeLast <- time[n]
midnightLast <- ISOdatetime(1900+timeLast$year, timeLast$mon+1, timeLast$mday, 0, 0, 0, tz="America/Halifax")
recent <- 86400 > (as.numeric(timeLast) - as.numeric(time))
t <- t[recent]
q <- q[recent]
time <- time[recent]

if (!interactive()) png("~/Sites/qt/plot01_detail.png", width=5, height=5, unit="in", res=120, pointsize=12)
par(mfrow=c(3,1))
# layout.show(nf)
days <- substr(range(time),1,10)
oce.plot.ts(time, t, ylab="T [C]", drawTimeRange=FALSE, mar=c(2, 3, 1, 1), col='darkred', lwd=2, grid=TRUE)
n <- length(t)
mtext(format(time[1], "%b %e, %Y"), side=3, adj=1, line=0, cex=0.7)

h <- humidex(t, q)
oce.plot.ts(time, h, ylab="Humidex [degC]", drawTimeRange=FALSE, mar=c(2, 3, 1, 1), col='darkred', lwd=2, grid=TRUE)
##lines(time[recent], h[recent], col='darkred', lwd=4)
points(time[n], h[n], col='darkred')

oce.plot.ts(time, q, ylab="Rel. Hum. [%]", drawTimeRange=FALSE, mar=c(2, 3, 1, 1), col='darkgreen', lwd=2, grid=TRUE)
##lines(time[recent], q[recent], col='darkgreen', lwd=4)
points(time[n], q[n], col='darkgreen')

if (!interactive()) dev.off()

