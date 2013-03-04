#STA 242 HOMEWORK 4
#YICHUAN WANG

#counting in R with file connection
#set the file to be read
filepath = "~/Downloads/Years1987_1999.tar"

#function to get the counts for each airports
apcount = function(path){
  #get the line count of the file with shell command
  totallines = system(paste("wc -l", path), intern = TRUE)
  totallines = as.numeric(gsub("[space]*([0-9]+) .+", "\\1", totallines))
  #create connection to the file
  con = file(filepath, open="rt")
  #construct vector for counting airports
  counts = structure(integer(4), names = c("LAX", "OAK","SFO", "SMF"))
  #while loop to read rest of the file
  while (TRUE) {
    #read about one tenth of total lines in connection
    lines.r = readLines(con, n = floor(totallines/10))
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
  counts
}