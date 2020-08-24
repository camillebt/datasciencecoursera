R Assignment: Air Pollution
================

# Introduction

**NOTE:** This markdown is for future reference on what codes were used
throughout the assignment.

For this first programming assignment you will write three functions
that are meant to interact with dataset that accompanies this
assignment. The dataset is contained in a zip file specdata.zip that you
can download from the Coursera web site.

Although this is a programming assignment, you will be assessed using a
separate quiz.

Data The zip file containing the data can be downloaded here:
[specdata.zip](https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2Fspecdata.zip)
\[2.4MB\]

The zip file contains 332 comma-separated-value (CSV) files containing
pollution monitoring data for fine particulate matter (PM) air pollution
at 332 locations in the United States. Each file contains data from a
single monitor and the ID number for each monitor is contained in the
file name. For example, data for monitor 200 is contained in the file
“200.csv”. Each file contains three variables:

Date: the date of the observation in YYYY-MM-DD format (year-month-day)
sulfate: the level of sulfate PM in the air on that date (measured in
micrograms per cubic meter) nitrate: the level of nitrate PM in the air
on that date (measured in micrograms per cubic meter)

For this programming assignment you will need to unzip this file and
create the directory ‘specdata’. Once you have unzipped the zip file, do
not make any modifications to the files in the ‘specdata’ directory. In
each file you’ll notice that there are many days where either sulfate or
nitrate (or both) are missing (coded as NA). This is common with air
pollution monitoring data in the United States.

## Part 1

Write a function named ‘pollutantmean’ that calculates the mean of a
pollutant (sulfate or nitrate) across a specified list of monitors. The
function ‘pollutantmean’ takes three arguments: ‘directory’,
‘pollutant’, and ‘id’. Given a vector monitor ID numbers,
‘pollutantmean’ reads that monitors’ particulate matter data from the
directory specified in the ‘directory’ argument and returns the mean of
the pollutant across all of the monitors, ignoring any missing values
coded as NA.

## Codes

Creating specdata directory and setting it as work directory

``` r
dir.create(specdata);
setwd("~/specdata/")
```

Downloading file from URL and unzipping into

``` r
temp_var <- templfile();
download.file(url,temp_var);
unzip(temp_var)
```

Function code

``` r
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
```

## Part 2

Write a function that reads a directory full of files and reports the
number of completely observed cases in each data file. The function
should return a data frame where the first column is the name of the
file and the second column is the number of complete cases.

## Codes

``` r
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
```

## Part 3

Write a function that takes a directory of data files and a threshold
for complete cases and calculates the correlation between sulfate and
nitrate for monitor locations where the number of completely observed
cases (on all variables) is greater than the threshold. The function
should return a vector of correlations for the monitors that meet the
threshold requirement. If no monitors meet the threshold requirement,
then the function should return a numeric vector of length 0.

For this function you will need to use the ‘cor’ function in R which
calculates the correlation between two vectors. Please read the help
page for this function via ‘?cor’ and make sure that you know how to use
it.

## Codes

``` r
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
  
  #csvcorr, once completed, should be the output
  return(csvcorr)
  
}
```
