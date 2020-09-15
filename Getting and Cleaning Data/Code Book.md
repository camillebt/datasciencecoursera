---
title: "Getting and Cleaning Data Project"
author: "Camille Tolentino"
output: github_document
---

## Data Source

[Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## Dataset Information

More data on [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Smartphone-Based+Recognition+of+Human+Activities+and+Postural+Transitions)

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


A video of the experiment including an example of the 6 recorded activities with one of the participants can be seen in the following link: [Web Link](http://www.youtube.com/watch?v=XOEN9W05_4A)

## Attribute Information
For each record in the dataset it is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope.
* A 561-feature vector with time and frequency domain variables.
* Its activity label.
* An identifier of the subject who carried out the experiment

## Goal of the Code
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names.
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Code to Tidy Data

```r
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
```

