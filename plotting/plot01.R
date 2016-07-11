library(oce)
library(RSQLite)
m <- dbDriver("SQLite")
con <- dbConnect(m, dbname="/Users/kelley/qt/database/qt.db")
observations <- dbGetQuery(con, "select time,t,q from observations")
## FIXME: check timezone
time <- as.POSIXlt(numberAsPOSIXct(observations$time, tz="America/Halifax"))
t <- observations$t
q <- observations$q
if (!interactive()) png("~/Sites/qt/plot01.png", width=7, height=3, unit="in", res=100)
nf <- layout(matrix(c(1,3,2,3), 2, 2, byrow = TRUE),widths=c(0.6,0.4),heights=c(0.5,0.5))
# layout.show(nf)
days <- substr(range(time),1,10)
oce.plot.ts(time, t, ylab="T [C]", drawTimeRange=FALSE, mar=c(2, 3, 1, 1), col='darkred', lwd=2)
points(time[1], t[1], col='darkred')
if (days[1] == days[2])
    mtext(format(time[1], "%b %e, %Y"), side=3, adj=1, line=0, cex=0.7)
oce.plot.ts(time, q, ylab="q [rel]", drawTimeRange=FALSE, mar=c(2, 3, 1, 1), col='darkgreen', lwd=2)
points(time[1], q[1], col='darkgreen')

par(mar=c(3, 3, 1, 1), mgp=c(2, 0.7, 0))

plot(t,q, type="l", xlab="T [C]", ylab="q [rel]")
points(t[1], q[1])

if (!interactive()) dev.off()

