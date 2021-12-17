# Load data

if(!file.exists("data")){dir.create("data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"data/dataset.zip")
files <- unzip("data/dataset.zip",exdir="data")
subject_train <- read.table(files[26])
subject_test  <- read.table(files[14])
activity_train <- read.table(files[28])
activity_test  <- read.table(files[16])
features_train  <- read.table(files[27])
features_test <- read.table(files[15])

# 1. Merge data sets

subject <- rbind(subject_train,subject_test)
activity <- rbind(activity_train,activity_test)
features <- rbind(features_train,features_test)
names(subject)<-"subject"
names(activity)<- "activity"
feature_names <- read.table(files[2])$V2
names(features) <- feature_names
dataset <- cbind(subject,activity,features)

# 2. Extract mean and standard deviation

mean_std_names <-grep("mean|std", feature_names, value=TRUE)
dataset <- subset(dataset, select= c("subject","activity", mean_std_names))

# 3. Use descriptive activity names

activity_names <- read.table(files[1])
dataset$activity <- activity_names[activity[[1]],2]

# 4. Label dataset with descriptive variable names

names(dataset)<-gsub("acc", "Accelerometer", names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("bodybody", "Body", names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("^f", "Frequency",names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("gyro", "Gyroscope",names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("mag", "Magnitude",names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("-mean\\(\\)", "Mean", names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("-meanFreq\\(\\)", "Mean", names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("^t", "Time", names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("-std\\(\\)", "STD",names(dataset), ignore.case = TRUE)

# 5. Create independant tidy dataset

tidy_dataset <- aggregate(.~subject+activity, dataset, mean)
tidy_dataset <- tidy_dataset[order(tidy_dataset$subject,tidy_dataset$activity),]
write.table(tidy_dataset, "tidy_dataset.txt", row.name=FALSE)

