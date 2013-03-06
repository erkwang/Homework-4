#STA 242 HOMEWORK 4
#YICHUAN WANG

#counting in R with integration of shell commands
shellexe = function(path){
  apnames = c("LAX", "OAK","SFO", "SMF")
  shellcount = character(4)
  shelldelay = list()
  for (i in 1:4) {
    cmd = paste("cut -f 16-17 -d , ",  path, " | grep ',",
                  apnames[i], "' | cut -f 1 -d , | tee ./", apnames[i],
                 " | wc -l",sep = "")
    shellcount[i] = system(cmd, intern = TRUE)
    shelldelay[[i]] = readLines(paste("./", apnames[i], sep = ""))
  }
  list(shellcount, shelldelay)
}

cut -f 16-17 -d , ~/Downloads/2008.csv | grep ',LAX' | cut -f 1 -d , | tee  ./LAX | wc -l &


bob = 
  system("cut -f 16-17 -d ,  ~/Downloads/2008.csv | grep ',LAX' | tee >(wc -l) >(cut -f 1 -d ,)",
         intern = TRUE)

