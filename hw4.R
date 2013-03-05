#STA 242 HOMEWORK 4
#YICHUAN WANG

#counting in R with file connection
#set the file to be read
filepath1 = "~/Downloads/Years1987_1999.tar"
filepath2 = "~/Downloads/Years2000_2008.tar"


#function to get the counts for each airports
apcount = function(path){
  #get the line count of the file with shell command
  totallines = system(paste("wc -l", path), intern = TRUE)
  totallines = as.numeric(gsub("[space]*([0-9]+) .+", "\\1", totallines))
  #create connection to the file
  con = file(path, open="rt")
  #construct vector for counting airports
  counts = structure(integer(4), names = c("LAX", "OAK","SFO", "SMF"))
  #initialize vectors for departure delaying time mean and sum of squares
  apmean = structure(numeric(4), names = c("LAX", "OAK","SFO", "SMF"))
  apsumsq = structure(numeric(4), names = c("LAX", "OAK","SFO", "SMF"))
  #while loop to read rest of the file
  while (TRUE) {
    #read about one tenth of total lines in connection
    lines.r = readLines(con, n = 5000000)
    #check if all the file has been read
    if (length(lines.r) == 0) break
    #split the block into columns
    lines.r = strsplit(lines.r, split=",")
    #grab the 17th column
    airports = sapply(lines.r, '[', 16:17)
    #count the lines containing the name in counts
    tmp = table(airports[2,])[names(counts)]
    tmp[is.na(tmp)] = 0
    #add it to counts
    counts = counts + tmp
    #get mean and ss of delaying time
    tmp2 = by(airports[1,], airports[2,], meanss)[names(counts)]
    meanvec = sapply(tmp2, function(x)x[1])
    ssvec = sapply(tmp2, function(x)x[2])
    #add them to mean and ss
    apmean = apmean + meanvec
    apsumsq = apsumsq + ssvec
  }
  close(con)
  return(list(count = counts, mean = apmean, ss = apsumsq))
}

#function to get mean and sum of squares
meanss = function(vec){
  vec = as.numeric(vec)
  foo1 = mean(vec, na.rm = TRUE)
  foo2 = sum(vec^2, na.rm = TRUE)
  c(foo1, foo2)
}

#run the function while recording time
Rprof("./Rprof.out")
count19 = apcount(filepath1)
count20 = apcount(filepath2)
