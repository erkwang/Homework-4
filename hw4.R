#STA 242 HOMEWORK 4
#YICHUAN WANG

#counting in R with file connection
#set the file to be read
filepath1 = "~/Downloads/Years1987_1999.tar"
filepath2 = "~/Downloads/Years2000_2008.tar"


#function to get the counts for each airports
apcount = function(path, B = 5000000){
  #create connection to the file
  con = pipe(paste("tar xf ", path, " -O | egrep 'LAX|OAK|SFO|SMF'", sep = ""))
  #construct vector for counting airports
  counts = structure(integer(4), names = c("LAX", "OAK","SFO", "SMF"))
  #initialize vectors for departure delaying time sum and sum of squares
  apsum = structure(numeric(4), names = c("LAX", "OAK","SFO", "SMF"))
  apsumsq = structure(numeric(4), names = c("LAX", "OAK","SFO", "SMF"))
  #while loop to read rest of the file
  while (TRUE) {
    #read about one tenth of total lines in connection
    lines.r = readLines(con, n = B)
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
    #get sum and ss of delaying time
    tmp2 = split(airports[1,], as.factor(airports[2,]))[names(counts)]
    tmp2 = lapply(tmp2, sumss)
    sumvec = sapply(tmp2, function(x)x[1])
    ssvec = sapply(tmp2, function(x)x[2])
    #add them to sum and ss
    apsum = apsum + sumvec
    apsumsq = apsumsq + ssvec
  }
  close(con)
  return(list(count = counts, sum = apsum, ss = apsumsq))
}

#function to get mean and sum of squares
sumss = function(vec){
  vec = as.numeric(vec)
  foo1 = sum(vec, na.rm = TRUE)
  foo2 = sum(vec^2, na.rm = TRUE)
  c(foo1, foo2)
}

#run the function while recording time
Rprof("./Rprof.out")
count19 = apcount(filepath1)
count20 = apcount(filepath2)

#obtain the total counts, overall mean and sd
countR = count19[[1]]+count20[[1]]
meanR = (count19[[2]]+count20[[2]])/countR
sdR = sqrt((count19[[3]] + count20[[3]] - countR * meanR^2)/(countR-1))
resultR = data.frame(count = countR, mean = meanR, sd = sdR)

