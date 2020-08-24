pollutantmean <- function(directory, pollutant, id = 1:332) {
  
  #take all files
  allfiles <- list.files(directory, full.names = TRUE)
  
  #create an empty data.frame
  maindata <- data.frame()
  
  #bind data from individual files and return maindata data.frame
  for(i in id){
    maindata <- rbind(maindata,read.csv(allfiles[i]))
  }
  #calculate mean on bound data.frame
  mean(maindata[,pollutant],na.rm=TRUE)
}
