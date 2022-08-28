
## Downloading data and unzipping to a dedicated folder "./data/UCIHARDataset"

fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(fileUrl,temp)
unzip(zipfile=temp,exdir="./data/UCIHARDataset")
unlink(temp) 

## Reading in key tables

trainset <- read.table("./data/UCIHARDataset/UCI HAR Dataset/train/X_train.txt")
trainnames <- read.table("./data/UCIHARDataset/UCI HAR Dataset/train/y_train.txt")
trainsubjects <- read.table("./data/UCIHARDataset/UCI HAR Dataset/train/subject_train.txt")

testset <- read.table("./data/UCIHARDataset/UCI HAR Dataset/test/X_test.txt")
testnames <- read.table("./data/UCIHARDataset/UCI HAR Dataset/test/y_test.txt")
testsubjects <- read.table("./data/UCIHARDataset/UCI HAR Dataset/test/subject_test.txt")

activitynames <- read.table("./data/UCIHARDataset/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/UCIHARDataset/UCI HAR Dataset/features.txt")

## Adding the following variables as last columns to both training set and test set:

## 1. Numeric class variable "activityid" with values from the first column of
## trainnames and testnames tables respectively 
## 2. Numeric class variable "subjectid" with values from the first columns of
## trainsubjects and testsubjects tables respectively
## 3. Character class variable "originalset"with values 
## "training" and "test" respectively

trainset <- cbind(trainset,activityid=trainnames[,1],subjectid=trainsubjects[,1],originalset=rep("train",nrow(trainset)))
testset <- cbind(testset,activityid=testnames[,1],subjectid=testsubjects[,1],originalset=rep("test",nrow(testset)))

## Further on the script does the following:

## 1. Merges the two sets into one dataset

mergedset <- merge(trainset,testset,all=TRUE,sort=FALSE)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

## Such measurements are identified as having "-mean()" or "-std()"in the feature name 
## where feature names are specified in the second columns of features table
## So for example, feature named "angle(tBodyAccJerkMean),gravityMean)"  will not be included
## But feature names"fBodyAccJerk-mean()-X" will be included.
## Extract is called "dataextract
## The variable denoting originalset is dropped in the extract

dataextract <- cbind(mergedset[,grep("-(mean\\(\\))|(-std\\(\\))",features[,2])],
                     activityid=mergedset$activityid,subjectid=mergedset$subjectid)

## 3.Uses descriptive activity names to name the activities in the data set

## Applies split & apply technique to the variable "activityid"
## Function getactivitname looks for activity ID in activitynames table
## And returns activity name instead

getactivityname <- function(n){i <- match(n,activitynames[,1]); activitynames[i,2]}
dataextract$activityid <- sapply(dataextract$activityid,getactivityname)

## 4. Appropriately labels the data set with descriptive variable names. 

colnames(dataextract)<- c(features[grep("-(mean\\(\\))|(-std\\(\\))",features[,2]),2],"activityname", "subjectid")  

## 5. From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject

## Dataextract2 is initially created from the earlier data extract
## By removing orignal columns activity names and subject id, 
## And adding a column that concatenates activity name and subject id
## Into a unique identifier
## Data is then split by the new identifier, adn colMeans function is applied
## For all remaining columns

dataextract2 <-cbind(dataextract[,-which(names(dataextract) %in% c("activityname","subjectid"))],
                     actsub=paste(dataextract$activityname, as.character(dataextract$subjectid)))
splitactsub <- split(dataextract2[,-which(names(dataextract2)=="actsub")],dataextract2$actsub)
dataextract2 <- sapply(splitactsub,colMeans,na.rm=TRUE)

