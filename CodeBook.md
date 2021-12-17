## Overview

The run\_analysis.R script creates a tidy and clean dataset from the
original data set. Information about the data set is available here:
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>.

## Load Data

-   Create data folder:

<!-- -->

    if(!file.exists("data")){dir.create("data")}

-   Set url to the data source:

<!-- -->

    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

-   Download zip file:

<!-- -->

    download.file(url,"data/dataset.zip")

-   Unzip file and create variable with the names of all the files:

<!-- -->

    files <- unzip("data/dataset.zip",exdir="data")

-   Create variables for train and test subject id data:

<!-- -->

    subject_train <- read.table(files[26])

    subject_test  <- read.table(files[14])

-   Create variables for train and test activity code data:

<!-- -->

    activity_train <- read.table(files[28])

    activity_test  <- read.table(files[16])

-   Create variables for train and test recorded features data:

<!-- -->

    features_train  <- read.table(files[27])

    features_test <- read.table(files[15])

## 1. Merge data sets

-   Merge train and test data sets using rbind:

<!-- -->

    subject <- rbind(subject_train,subject_test)
    activity <- rbind(activity_train,activity_test)
    features <- rbind(features_train,features_test)

-   Set initial column names:

<!-- -->

    names(subject)<-"subject"
    names(activity)<- "activity"
    feature_names <- read.table(files[2])$V2
    names(features) <- feature_names

-   Merge columns into single data set using cbind:

<!-- -->

    dataset <- cbind(subject,activity,features)

## 2. Extract mean and standard deviation

-   Select names referring to mean and standard deviation measurements

<!-- -->

    mean_std_names <-grep("mean|std", feature_names, value=TRUE)

-   Subset data according to the selected names

<!-- -->

    dataset <- subset(dataset, select= c("subject","activity", mean_std_names))

## 3. Use descriptive activity names

-   Create variable with the activity names:

<!-- -->

    activity_names <- read.table(files[1])

-   Replace activity codes with activity names

<!-- -->

    dataset$activity <- activity_names[activity[[1]],2]

## 4. Label dataset with descriptive variable names

-   Clean up non descriptive variable names using the gsub command:

<!-- -->

    names(dataset)<-gsub("acc", "Accelerometer", names(dataset), ignore.case = TRUE)
    names(dataset)<-gsub("bodybody", "Body", names(dataset), ignore.case = TRUE)
    names(dataset)<-gsub("^f", "Frequency",names(dataset), ignore.case = TRUE)
    names(dataset)<-gsub("gyro", "Gyroscope",names(dataset), ignore.case = TRUE)
    names(dataset)<-gsub("mag", "Magnitude",names(dataset), ignore.case = TRUE)
    names(dataset)<-gsub("-mean\\(\\)", "Mean", names(dataset), ignore.case = TRUE)
    names(dataset)<-gsub("-meanFreq\\(\\)", "Mean", names(dataset), ignore.case = TRUE)
    names(dataset)<-gsub("^t", "Time", names(dataset), ignore.case = TRUE)
    names(dataset)<-gsub("-std\\(\\)", "STD",names(dataset), ignore.case = TRUE)

## 5. Create independant tidy dataset

-   Calculate the mean of each variable grouped by subject and activity

<!-- -->

    tidy_dataset <- aggregate(.~subject+activity, dataset, mean)

-   Order the rows according to subject and activity

<!-- -->

    tidy_dataset <- tidy_dataset[order(tidy_dataset$subject,tidy_dataset$activity),]

-   Write tidy dataset to file:

<!-- -->

    write.table(tidy_dataset, "tidy_dataset.txt", row.name=FALSE)
