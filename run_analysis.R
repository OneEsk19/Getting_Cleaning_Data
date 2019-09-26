## load all the data files into R

# read in the features and activity labels key files
setwd("~/Coursera/gettingandcleaningdata/WEEK4/Assignment/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

# read in the test datasets
setwd("~/Coursera/gettingandcleaningdata/WEEK4/Assignment/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test")
x_test <- read.table("X_test.txt")
subject_test <- read.table("subject_test.txt")
y_test <- read.table("Y_test.txt")

# read in the train datasets
setwd("~/Coursera/gettingandcleaningdata/WEEK4/Assignment/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train")
x_train <- read.table("X_train.txt")
subject_train <- read.table("subject_train.txt")
y_train <- read.table("Y_train.txt")

# set column names for test and train data using the descriptiosn in the features dataframe
colnames(x_test) <- features[(1:561),2]
colnames(x_train) <- features[(1:561),2]

# replace number coded activity in y_test and y_train with a descriptive activity label
# rename the column (V1) to Activity in each table
y_test[y_test == 6] <- "LAYING"
y_test[y_test == 5] <- "STANDING"
y_test[y_test == 4] <- "SITTING"
y_test[y_test == 3] <- "WALK_DOWNST"
y_test[y_test == 2] <- "WALK_UPST"
y_test[y_test == 1] <- "WALKING"
colnames(y_test) <- "Activity"

y_train[y_train == 6] <- "LAYING"
y_train[y_train == 5] <- "STANDING"
y_train[y_train == 4] <- "SITTING"
y_train[y_train == 3] <- "WALK_DOWNST"
y_train[y_train == 2] <- "WALK_UPST"
y_train[y_train == 1] <- "WALKING"
colnames(y_train) <- "Activity"

# bind the activity data (y_test and y_train) to the test and train data
testActivity <- cbind(y_test, x_test)
trainActivity <- cbind(y_train, x_train)

# rename the V1 columns in subject datatables to "Test_Subject" and 
colnames(subject_test) <- "Test_Subject"
colnames(subject_train) <- "Test_Subject"

# bind the subject data to the appropriate files
allTest <- cbind(subject_test, testActivity)
allTrain <-cbind(subject_train, trainActivity)

# merge the test and train dataframes and rename column V1 to 
all_data <- rbind(allTest, allTrain)


## Extracts only the measurements on the mean and standard deviation for each measurement
meanstd <- all_data[,c(grep("Test_Subject|Activity|mean|std",names(all_data)))]

## Create a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)

avgActivityData <- meanstd %>%
  group_by(Test_Subject, Activity) %>%
  summarise_all(mean)

