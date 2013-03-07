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
apcountsql = dbGetQuery(dbcon, "SELECT count(*) 
                                FROM delays WHERE origin = 'LAX' OR origin = 'SFO' 
                                OR origin = 'OAK' OR origin = 'SMF' 
                                GROUP BY origin")
apmeansql = dbGetQuery(dbcon, "SELECT AVG(DepTime) 
                               FROM delays WHERE origin = 'LAX' OR origin = 'SFO' 
                               OR origin = 'OAK' OR origin = 'SMF' 
                               GROUP BY origin")

apsdsql = dbGetQuery(dbcon, 












