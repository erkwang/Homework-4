#SQLite database operations

#R code for combining all csv files

csvls = list.files("~/Downloads/", pattern = "[0-9]+\\.csv", full.names=TRUE,
                   recursive=TRUE)
writecon = file("~/Downloads/allairline.csv", open = "at")

sapply(csvls, function(path){
  readcon = file(path, open="rt")
  foo = readLines(readcon)[-1]
  
  close(readcon)
})

close(writecon)

#the database airline.db was created in sqlite with given code and the csv file
library(RSQLite)
#connect to database
drv = dbDriver("SQLite")
dbcon = dbConnect(drv, dbname = "~/Downloads/airline.db")

#calculate counts and mean departure delaying time for each airport
timesql = system.time({
apcountsql = dbGetQuery(dbcon, "SELECT count(*) 
                                FROM delays WHERE origin = 'LAX' OR origin = 'SFO' 
                                OR origin = 'OAK' OR origin = 'SMF' 
                                GROUP BY origin")
})
#track time for other two query calls
Rprof("~/Downloads/sql.out")
apmeansql = dbGetQuery(dbcon, "SELECT AVG(DepDelay) 
                               FROM delays WHERE origin = 'LAX' OR origin = 'SFO' 
                               OR origin = 'OAK' OR origin = 'SMF' 
                               GROUP BY origin")

#calculate sd and departure delay with function extensions
library(RSQLite.extfuns)
init_extensions(db=dbcon)
apsdsql = dbGetQuery(dbcon, "SELECT STDEV(DepDelay)
                             FROM delays WHERE origin = 'LAX' OR origin = 'SFO' 
                             OR origin = 'OAK' OR origin = 'SMF' 
                             GROUP BY origin")
#close connection and unload driver
dbDisconnect(dbcon)
dbUnloadDriver(drv)

#give names to values in results
resultsql = cbind(apcountsql, apmeansql, apsdsql)
rownames(resultsql) = c("LAX", "OAK", "SFO", "SMF")












