#Load packages
library(data.table)
library(dplyr)

#Check if file already downloaded and if not, download and save time saved
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
path <- getwd()
if (!file.exists(dataFile)){
  download.file(url, file.path(path, "dataFiles.zip"))
}
if (!file.exists("./UCI HAR Dataset")){
  unzip(dataFile)
}
tstp <- date()

#Reading data per file
setwd("./UCI HAR Dataset")
y_Test <- read.table("./test/y_test.txt", header = F)
y_Train <- read.table("./train/y_train.txt", header = F)
x_Test <- read.table("./test/X_test.txt", header = F)
x_Train <- read.table("./train/X_train.txt", header = F)
Sub_Test <- read.table("./test/subject_test.txt", header = F)
Sub_Train <- read.table("./train/subject_train.txt", header = F)
Act_Labels <- read.table("./activity_labels.txt", header = F)
Features <- read.table("./features.txt", header = F)

#Merging datasets
x_Data <- rbind(x_Train,x_Test)
y_Data <- rbind(y_Train,y_Test)
Sub_Data <- rbind(Sub_Test, Sub_Train)

#Renaming columns
names(y_Data) <- "Activity_Num"
names(Act_Labels) <- c("Activity_Num", "Activity")

#Getting factor per activity
Activity <- left_join(y_Data, Act_Labels, "Activity_Num")[, 2]

#Rename SubjectData columns
names(Sub_Data) <- "Subject"

#Rename FeaturesData columns using columns from FeaturesNames
names(x_Data) <- Features$V2

#Extract dataset with only one variable per column
T_Data <- cbind(Sub_Data,Activity,x_Data)

#Extract only the measurements on the mean and standard deviation for each measurement
subFeatures <- Features$V2[grep("mean\\(\\)|std\\(\\)", Features$V2)]
DataNames <- c("Subject", "Activity", as.character(subFeatures))
T_Data <- subset(T_Data, select=DataNames)

#Rename columns to be more intuitive
names(T_Data)<-gsub("^t", "time", names(T_Data))
names(T_Data)<-gsub("^f", "frequency", names(T_Data))
names(T_Data)<-gsub("Acc", "Accelerometer", names(T_Data))
names(T_Data)<-gsub("Gyro", "Gyroscope", names(T_Data))
names(T_Data)<-gsub("Mag", "Magnitude", names(T_Data))
names(T_Data)<-gsub("BodyBody", "Body", names(T_Data))

#Tidy dataset with the average of each variable for each activity and each subject
tidy_Data<-aggregate(. ~Subject + Activity, T_Data, mean)
tidy_Data<-tidy_Data[order(tidy_Data$Subject,tidy_Data$Activity),]
write.table(tidy_Data, file = "tidydata.txt",row.name=FALSE)
