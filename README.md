---
title: "README"
author: "G.Robertson"
date: "25/09/2019"
output: html_document
---

Overview
========
The UCI HAR Dataset (Anguita et al., 2012) contains the experimental results of a series of tests in which paricipants performed a range of physical activities while wearing a smartphone on thier person. Data were obtained from the smartphones' gyroscope and accelerometer and mapped to a defined activity.

UCI HAR dataset available at: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Data Set Files
==============

*Root Directory*  
- activity_labels.txt - shows the name of the physical activity in relation to its numerical key as used in the raw data files.  
- features.txt - a list of all the experimental variables in the raw data files.  
- features_info.txt -  gives a description of the variables used in the raw data.  
- README.txt - a detailed overview of the experiment, datasets, and files.   

*Test & Train Directories*  
Inertial Signals Directory - Contains the raw data obtained from the smartphones.  
X_Test / X_train - Processed test and training sets.  
Y_test / Y_train - Activity keys for the above datasets.  
subject_test / subject_train - Participant keys for the above datasets.  

Analyses
========
*Objectives*  
1) Merge the training and the test sets to create one data set.  
2) Extract only the measurements on the mean and standard deviation for each measurement.   
3) Uses descriptive activity names to name the activities in the data set.  
4) Appropriately labels the data set with descriptive variable names.  
5) create a second, independent tidy data set with the average of each variable for each activity and each subject.

*Methods*  
As detailed in run_analysis.R   

1) Load all relevant data files into R as appropriately labelled objects (dataframes):  
- activity_labels  
- features  
- x_test, x_train  
- y_test, y_train  
- subject_test, subject_train  
`activity_labels <- read.table("activity_labels.txt")`  
`features <- read.table("features.txt")`  
`x_test <- read.table("X_test.txt")`  
`subject_test <- read.table("subject_test.txt")`  
`y_test <- read.table("Y_test.txt")`  
`x_train <- read.table("X_train.txt")`  
`subject_train <- read.table("subject_train.txt")`  
`y_train <- read.table("Y_train.txt")`  

2) Set the names of the variables (columns) in test and training sets using the features dataframe.
`colnames(x_test) <- features[(1:561),2]`  
`colnames(x_train) <- features[(1:561),2]`

3) Replace number coded activity in y_test and y_train with a descriptive activity label and rename the column header (V1) to "Activity"" in each table.  
`y_test[y_test == 6] <- "LAYING"`  
`y_test[y_test == 5] <- "STANDING"`  
`y_test[y_test == 4] <- "SITTING"`  
`y_test[y_test == 3] <- "WALK_DOWNST"`  
`y_test[y_test == 2] <- "WALK_UPST"`  
`y_test[y_test == 1] <- "WALKING"`  
`colnames(y_test) <- "Activity"`  
`y_train[y_train == 6] <- "LAYING"`  
`y_train[y_train == 5] <- "STANDING"`  
`y_train[y_train == 4] <- "SITTING"`  
`y_train[y_train == 3] <- "WALK_DOWNST"`  
`y_train[y_train == 2] <- "WALK_UPST"`  
`y_train[y_train == 1] <- "WALKING"`  
`colnames(y_train) <- "Activity"`  

4) Bind the relevant activity data to the test and train sets.  
`testActivity <- cbind(y_test, x_test)`  
`trainActivity <- cbind(y_train, x_train)`  

5) Rename the column header in suject datatables to "Test_Subject" and bind each suject file to the appropriate activity data file.  
`colnames(subject_test) <- "Test_Subject"`  
`colnames(subject_train) <- "Test_Subject"`  
`allTest <- cbind(subject_test, testActivity)`  
`allTrain <-cbind(subject_train, trainActivity)`  

6) Merge the test and train datatables into one datatable containing all test and train data.  
`all_data <- rbind(allTest, allTrain)`  

7) Extract only the means and standard deviation variables from the merged data into a new datatable.  
`meanstd <- all_data[,c(grep("Test_Subject|Activity|mean|std",names(all_data)))]`

8) Use the above dataset to create a separate table in which variables are grouped by (i) test subject and (ii) activity and then averaged.  
`library(dplyr)`  
`avgActivityData <- meanstd %>%`  
  `group_by(Test_Subject, Activity) %>%`  
  `summarise_all(mean)`  


Reference
=========
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012