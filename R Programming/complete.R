complete <- function(directory, id=1:332){
  
  #take all files
  allfiles <- list.files(directory, full.names = TRUE)
  
  #define nobs
  nobs <-numeric()
  
  #for each iteration add sum of partial nobs into a list of nobs
  for(i in id){
    
    #read the csv data and save it into a data.frame
    csvdata <-read.csv(allfiles[i])
    
    #using built in function complete.cases assign nobs
    partnobs <- sum(complete.cases(csvdata))
    nobs <- c(nobs,partnobs)
    
  }
  
  #set output to be a data.frame giving out nobs per ID
  data.frame(id,nobs)
  
  
}
