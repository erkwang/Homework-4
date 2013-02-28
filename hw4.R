#STA 242 HOMEWORK 4
#YICHUAN WANG

#counting in R with file connection
#create connection to .bz2 file
con = bzfile("~/Downloads/2008.csv.bz2", open="rt")
#read the first one hundred lines
lines.r = readLines(con, n = 100)
#construct vector for counting airports
counts = structure(0, names = "LAX")
#while loop to read rest of the file
while (!is.null(lines.r)) {
  #count the lines containing the name in counts
  counts[names(counts)] = sum(grepl(names(counts), lines.r))
  #read the next 100 lines in connection
  lines.r = lines.r = readLines(con, n = 100)
}
