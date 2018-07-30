#set working directory
setwd("~/Coursera")
#download zip file
if(!file.exists("./get-clean-data")){dir.create("./get-clean-data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./get-clean-data/Dataset.zip")

# Unzip dataSet to /get-clean-data directory
unzip(zipfile="./get-clean-data/Dataset.zip",exdir="./get-clean-data")

# reading training tables:
x_train <- read.table("./get-clean-data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./get-clean-data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./get-clean-data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./get-clean-data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./get-clean-data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./get-clean-data/UCI HAR Dataset/test/subject_test.txt")

# reading features vector:
features <- read.table('./get-clean-data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./get-clean-data/UCI HAR Dataset/activity_labels.txt')

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#Merges the training and the test sets to create one data set.
merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
MergedSet <- rbind(merge_train, merge_test)

#read column names
colNames <- colnames(MergedSet)

#create vector for ID, mean and std deviation
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

#Extracts only the measurements on the mean and standard deviation for each measurement.
setOfMeanAndStdDev <- MergedSet[ , mean_and_std == TRUE]

#Appropriately labels the data set with descriptive variable names.
setWithActivityNames <- merge(setOfMeanAndStdDev, activityLabels,
                              by='activityId',
                              all.x=TRUE)
#make second tidy dataset
TidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
TidySet <- TidySet[order(TidySet$subjectId, TidySet$activityId),]

#From the data set in step 4, creates a second, independent tidy data set with the average 
#of each variable for each activity and each subject.

#write tidy dataset to file
write.table(TidySet, "TidySet.txt", row.name=FALSE)
