library(oce)
library(RSQLite)
N <- 10 * 86400 / 600                  # samples on 600s interval
m <- dbDriver("SQLite")
con <- dbConnect(m, dbname="/Users/kelley/databases/qt.db")
stations <- dbGetQuery(con, "select * from stations")
observations <- dbGetQuery(con, "select time,station_code,t,q from observations")
station <- subset(stations, station_code==observations$station_code[1])$station_name
## NB: timezine stored as UTC, so must convert
time <- as.POSIXlt(numberAsPOSIXct(observations$time, tz="America/Halifax"))
timel <- as.POSIXlt(time)
t <- observations$t
q <- observations$q

latest <- timel[length(timel)]
recent <- abs(as.numeric(time) - as.numeric(latest)) < 4 * 86400

time <- time[recent]
t <- t[recent]
q <- q[recent]

n <- length(time)
midnightLast <- ISOdatetime(1900+latest$year, latest$mon+1, latest$mday, 0, 0, 0, tz="America/Halifax")
recent <- time >= midnightLast

if (!interactive()) png("~/Sites/qt/plot02.png", width=6.5, height=3.5, unit="in", res=100)
par(xpd=NA)
par(mfrow=c(1,2))
par(mar=c(1, 1, 1, 1))
cex <- 0.8
gridcol <- 'lightgray'

circlex <- sin(seq(0, 2*pi, length.out=128))
circley <- cos(seq(0, 2*pi, length.out=128))

h <- time$hour
m <- time$min
s <- time$sec
hour <- h + (m + s / 60) / 60
hourRadians <- hour * 2 * pi / 24
theta <- hourRadians - pi
t0 <- 10
tt <- t - t0
x <- tt * sin(theta)
y <- tt * cos(theta)
tlim <- c(-30, 30)
plot(x, y, asp=1, type='l', xlim=tlim, ylim=tlim, xlab="", ylab="", axes=FALSE, lwd=1.4, col='darkred')
##lines(x[recent], y[recent], lwd=4, col='darkred')
points(x[n], y[n], col='darkred', pch=20)
for (ring in seq(t0, 40, 5)) {
    hilite <- ring == 25
    lines((ring-t0) * circlex, (ring-t0) * circley, col=if (hilite) "black" else gridcol)
}
p <- 30
lines(c(0, 0), c(-p, p), col=gridcol)
lines(c(-p, p), c(0, 0), col=gridcol)
#for (ring in pretty(c(tt, 0))) {
mtext("Temperature", side=3, line=0, cex=cex, adj=0, font=2)
mtext(expression("5"*degree*C*" contours,"), side=3, line=-1, cex=cex, adj=0)
mtext(expression("25"*degree*"C bold"), side=3, line=-1.75, cex=cex, adj=0)
p <- 33
text(0, -p, "0h", cex=cex)
text(-p, 0, "6h", cex=cex)
text(0, p, "12h", cex=cex)
text(p, 0, "18h", cex=cex)

x <- q * sin(theta)
y <- q * cos(theta)
qlim <- c(-100, 100)
plot(x, y, asp=1, type='l', xlim=qlim, ylim=qlim, xlab="", ylab="", axes=FALSE, lwd=1.4, col='darkgreen')
##lines(x[recent], y[recent], lwd=4, col='darkgreen')
points(x[n], y[n], col='darkgreen', pch=20)
for (ring in seq(0, 100, 20)) {
    hilite <- ring == 60
    lines(ring * circlex, ring * circley, col=if (hilite) "black" else gridcol)
}
p <- 110
lines(c(0, 0), c(-100, 100), col=gridcol)
lines(c(-100, 100), c(0, 0), col=gridcol)
mtext("Relative Humidity", side=3, line=0, cex=cex, adj=1, font=2)
mtext("20% contours,", side=3, line=-1, adj=1, cex=cex)
mtext("60% bold", side=3, line=-1.75, adj=1, cex=cex)
text(0, -p, "0h", cex=cex)
text(-p, 0, "6h", cex=cex)
text(0, p, "12h", cex=cex)
text(p, 0, "18h", cex=cex)


## Overall title. There is a better way to do this but I cannot recall it.
par(new=TRUE)
par(mfrow=c(1,1))
par(usr=c(0,1,0,1))
text(0.5, 1, station, font=2, cex=1.1)

if (!interactive()) dev.off()
