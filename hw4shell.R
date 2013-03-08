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

#abtain the result from given file
Rprof("./shell.out")
shell19 = shellexe("./Years1987_1999.tar")
shell20 = shellexe("./Years2000_2008.tar")

#combine and analyze result
countshell = as.numeric(shell19[[1]])+as.numeric(shell20[[1]])
names(countshell) = c("LAX", "OAK", "SFO", "SMF")
depdelayshell = lapply(1:4, function(i){
  as.numeric(c(shell19[[2]][[i]],shell20[[2]][[i]]))})
meanshell = sapply(depdelayshell, mean, na.rm = TRUE)
sdshell = sapply(depdelayshell, sd, na.rm = TRUE)
resultshell = data.frame(count = countshell, mean = meanshell, sd = sdshell)


