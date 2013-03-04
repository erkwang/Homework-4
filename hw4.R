#STA 242 HOMEWORK 4
#YICHUAN WANG

#counting in R with file connection
#create connection to .bz2 file
con = file("~/Downloads/2008.csv", open="rt")
#read the first one hundred lines as a block
lines.r = readLines(con, n = 10000)
#split the block into columns
lines.r = strsplit(lines.r, split=",")
#grab the 17th column
airports = sapply(lines.r, '[[', 17)
#construct vector for counting airports
counts = structure(integer(4), names = c("LAX", "OAK","SFO", "SMF"))
counts[names(counts)] = table(airports)[names(counts)]
counts[is.na(counts)] = 0
#while loop to read rest of the file
while (!is.null(lines.r)) {
  #count the lines containing the name in counts
  counts = counts + table(airports)[names(counts)]
  #read the next 100 lines in connection
  lines.r = lines.r = readLines(con, n = 10000)
}
