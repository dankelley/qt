library(oce)
library(RSQLite)
m <- dbDriver("SQLite")
con <- dbConnect(m, dbname="/Users/kelley/qt/database/qt.db")
observations <- dbGetQuery(con, "select time,t,q from observations")
## FIXME: check timezone
time <- numberAsPOSIXct(observations$time) - 3 * 3600

t <- observations$t
q <- observations$q
if (!interactive()) png("plot02.png", width=6.5, height=3, unit="in", res=100)
par(xpd=NA)
par(mfrow=c(1,2), mar=c(1, 1, 1, 1))
cex <- 0.8
gridcol <- 'lightgray'

circlex <- sin(seq(0, 2*pi, length.out=128))
circley <- cos(seq(0, 2*pi, length.out=128))

hour <- as.POSIXlt(time)$hour
min <- as.POSIXlt(time)$min
sec <- as.POSIXlt(time)$sec
hms <- hour + (min + sec / 60) / 60
theta <- hms * 2 * pi / 24
theta <- theta
t0 <- -20
t20 <- t - t0
x <- t20 * sin(theta)
y <- t20 * cos(theta)
tlim <- 1.1 * max(t20) * c(-1, 1)
tlim <- c(-50, 50)
plot(x, y, asp=1, type='l', xlim=tlim, ylim=tlim, xlab="", ylab="", axes=FALSE, lwd=3,
     col='darkred')
for (ring in seq(-20, 30, 10)) {
    hilite <- ring == 20
    lines((ring-t0) * circlex, (ring-t0) * circley, col=if (hilite) "black" else gridcol)
}
lines(c(0, 0), c(-50, 50), col=gridcol)
lines(c(-50, 50), c(0, 0), col=gridcol)
#for (ring in pretty(c(t20, 0))) {
mtext(expression("10"*degree*C*" contours,"), side=3, line=-1, cex=cex, adj=0)
mtext(expression("20"*degree*"C bold"), side=3, line=-1.75, cex=cex, adj=0)
p <- 55
text(0, p, "0h", cex=cex)
text(p, 0, "6h", cex=cex)
text(0, -p, "12h", cex=cex)
text(-p, 0, "18h", cex=cex)

x <- q * sin(theta)
y <- q * cos(theta)
qlim <- 1.1 * max(q) * c(-1, 1)
qlim <- c(-100, 100)
plot(x, y, asp=1, type='l', xlim=qlim, ylim=qlim, xlab="", ylab="", axes=FALSE, lwd=3,
     col='darkgreen')
for (ring in seq(0, 100, 20)) {
    hilite <- ring == 60
    lines(ring * circlex, ring * circley, col=if (hilite) "black" else gridcol)
}
lines(c(0, 0), c(-100, 100), col=gridcol)
lines(c(-100, 100), c(0, 0), col=gridcol)
mtext("20% contours,", side=3, line=-1, adj=1, cex=cex)
mtext("60% bold", side=3, line=-1.75, adj=1, cex=cex)
p <- 110
text(0, p, "0h", cex=cex)
text(p, 0, "6h", cex=cex)
text(0, -p, "12h", cex=cex)
text(-p, 0, "18h", cex=cex)

if (!interactive()) dev.off()

