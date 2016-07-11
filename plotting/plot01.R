library(oce)
library(RSQLite)
m <- dbDriver("SQLite")
con <- dbConnect(m, dbname="/Users/kelley/qt/database/qt.db")
observations <- dbGetQuery(con, "select time,t,q from observations")
## FIXME: check timezone
time <- numberAsPOSIXct(observations$time) - 2 * 3600
t <- observations$t
q <- observations$q
if (!interactive()) png("~/Sites/qt/plot01.png", width=7, height=3, unit="in", res=100)
nf <- layout(matrix(c(1,3,2,3), 2, 2, byrow = TRUE),widths=c(0.6,0.4),heights=c(0.5,0.5))
# layout.show(nf)
days <- substr(range(time),1,10)
oce.plot.ts(time, t, ylab="T [C]", drawTimeRange=FALSE, mar=c(2, 3, 1, 1)) #, type='o')
if (days[1] == days[2])
    mtext(format(time[1], "%b %e, %Y"), side=3, adj=1, line=0, cex=0.7)
oce.plot.ts(time, q, ylab="q [rel]", drawTimeRange=FALSE, mar=c(2, 3, 1, 1))
par(mar=c(3, 3, 1, 1), mgp=c(2, 0.7, 0))

plot(t,q, type="l", xlab="T [C]", ylab="q [rel]")
if (!interactive()) dev.off()

