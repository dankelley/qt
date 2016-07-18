library(oce)
library(RSQLite)
equilibriumVaporPressure <- function(t, p=1000) {
    ## Buck formula
    ## https://en.wikipedia.org/wiki/Relative_humidity#Measurement
    (1.0007 + 3.46e-6*p) * 6.1121*exp(17.502*t/(240.97+t))
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
recent <- time >= midnightLast
t <- t[recent]
q <- q[recent]
time <- time[recent]

if (!interactive()) png("~/Sites/qt/plot01_detail.png", width=5, height=3, unit="in", res=120, pointsize=9)
par(mfrow=c(2,1))
# layout.show(nf)
days <- substr(range(time),1,10)
oce.plot.ts(time, t, ylab="T [C]", drawTimeRange=FALSE, mar=c(2, 3, 1, 1), col='darkred', lwd=2, grid=TRUE)
n <- length(t)
mtext(format(time[1], "%b %e, %Y"), side=3, adj=1, line=0, cex=0.7)

oce.plot.ts(time, q, ylab="Rel. Hum. [%]", drawTimeRange=FALSE, mar=c(2, 3, 1, 1), col='darkgreen', lwd=2, grid=TRUE)

if (!interactive()) dev.off()

