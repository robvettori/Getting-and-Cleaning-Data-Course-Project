library(dplyr)
library(reshape2)

filename <- "dataset.zip"
datafolder <- "UCI HAR Dataset"

## Download and unzip the dataset:
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(fileURL, filename)
}  
if (!file.exists(datafolder)) { 
        unzip(filename) 
}

## Load activity labels + features
activityLabels <- read.table(paste0(datafolder,"/activity_labels.txt"))
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table(paste0(datafolder,"/features.txt"))
features[,2] <- as.character(features[,2])

## Extract only the data on mean and standard deviation
index <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted <- features[index,2]

## Clean labels to create consistency 
featuresWanted <- gsub('-mean', 'Mean', featuresWanted)
featuresWanted <- gsub('-std', 'Std', featuresWanted)
featuresWanted <- gsub('[-()]', '', featuresWanted)

## Load the datasets
trainx <- read.table("UCI HAR Dataset/train/X_train.txt")[index]
trainy <- read.table("UCI HAR Dataset/train/y_train.txt")
trainsubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainsubjects, trainy, trainx)
# train <- train[index,]

testx <- read.table("UCI HAR Dataset/test/X_test.txt")[index]
testy <- read.table("UCI HAR Dataset/test/Y_test.txt")
testsubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testsubjects, testy, testx)
#test <- test[index,]

## merge datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresWanted)

## turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], 
                           labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

## Collapse data into fewer columns
allData <- melt(allData, id = c("subject", "activity"))

## Extract means from data
allDataMeans <- dcast(allData, subject + activity ~ variable, mean)

## Write file
write.table(allDataMeans, "tidy.txt", row.names = FALSE, quote = FALSE)
