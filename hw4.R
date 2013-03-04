#STA 242 HOMEWORK 4
#YICHUAN WANG

#counting in R with file connection
#create connection to the file
con = file("~/Downloads/2008.csv", open="rt")
#construct vector for counting airports
counts = structure(integer(4), names = c("LAX", "OAK","SFO", "SMF"))
#while loop to read rest of the file
while (TRUE) {
  #read the next 100 lines in connection
  lines.r = readLines(con, n = 1000000)
  #check if all the file has been read
  if (length(lines.r) == 0) break
  #split the block into columns
  lines.r = strsplit(lines.r, split=",")
  #grab the 17th column
  airports = sapply(lines.r, '[[', 17)
  #count the lines containing the name in counts
  tmp = table(airports)[names(counts)]
  tmp[is.na(tmp)] = 0
  #add it to counts
  counts = counts + tmp
}
