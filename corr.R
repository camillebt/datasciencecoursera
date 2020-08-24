corr <- function(directory,threshold = 0){
  
  #take all files
  allfiles <- list.files(directory, full.names = TRUE)
  
  #use function complete from part 2 to get nobs and save it into a data.frame
  compdf<- complete(directory)
  
  #check which ids have nobs>threshold and save them into a list
  ids <- compdf[compdf["nobs"] > threshold,]$id
  
  csvcorr<- numeric()
  
  for(i in ids){
    
    #read the csv data and save it into a data.frame
    csvdata<-read.csv(allfiles[i])
    
    #get only complete cases from csvdata and save it into a new data.frame
    corrdata <- csvdata[complete.cases(csvdata),]
    
    #calculate covariance between nitrate and sulfate
    csvcorr <- c(csvcorr,cor(corrdata$sulfate,corrdata$nitrate))
    
  }
  
  return(csvcorr)
  
}