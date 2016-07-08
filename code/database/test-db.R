library(oce)
library(RSQLite)
m <- dbDriver("SQLite")
con <- dbConnect(m, dbname="qt.db")
dbListTables(con)
observations <- dbGetQuery(con, "select time,q,t from observations")
time <- numberAsPOSIXct(observations$time) # timezone?
q <- observations$q
t <- observations$t
oce.plot.ts(time, q, ylab="Humditidy")
oce.plot.ts(time, t, ylab="Temperature")
