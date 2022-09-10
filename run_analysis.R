
## Downloading data and unzipping to a dedicated folder "./data"

fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(fileUrl,temp)
unzip(zipfile=temp,exdir="./data")
unlink(temp) 

## Reading in data components

trainset <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
trainnames <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
trainsubjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

testset <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
testnames <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
testsubjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

activitynames <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")

## Combining training- and test- data sets
## Adding Character class variable "originalset"with values "training" and "test" respectively

trainset <- cbind(trainset,activityid=trainnames[,1],
                  subjectid=trainsubjects[,1],originalset=rep("train",nrow(trainset)))
testset <- cbind(testset,activityid=testnames[,1],
                 subjectid=testsubjects[,1],originalset=rep("test",nrow(testset)))

## Further on the script does the following:

## 1. Merges the two sets into one dataset

mergedset <- merge(trainset,testset,all=TRUE,sort=FALSE)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

## Such measurements are identified as having "-mean()" or "-std()"in the feature name 
## where feature names are specified in the second column of the "features" table
## So for example, feature named "angle(tBodyAccJerkMean),gravityMean)"  will not be included
## But feature names"fBodyAccJerk-mean()-X" will be included.
## Extract is called "dataextract"
## The extract also includes "activityid" and "subjectid" variables
## The variable "originalset" is dropped in the extract

dataextract <- cbind(mergedset[,grep("-(mean\\(\\))|(-std\\(\\))",features[,2])],
                     activityid=mergedset$activityid,subjectid=mergedset$subjectid)

## 3.Uses descriptive activity names to name the activities in the data set

## Applies split & apply technique to the variable "activityid"
## The resulting set has activity name value where previously there was id

getactivityname <- function(n){i <- match(n,activitynames[,1]); activitynames[i,2]}
dataextract$activityid <- sapply(dataextract$activityid,getactivityname)

## 4. Appropriately labels the data set with descriptive variable names.

## Feature names are used as variable names,
## "activityid" variable name is replaced with "activityname",
## "subjectid" variable name remains unchanged.

colnames(dataextract)<- c(features[grep("-(mean\\(\\))|(-std\\(\\))",features[,2]),2],"activityname", "subjectid")  

## 5. From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject

## "newdataextract" is created from the earlier data extract
## By replacing original variables "activityname" and "subjectid", 
## With a variable "actsub" that concatenates activity name and subject id
## Into a unique identifier.

newdataextract <-cbind(dataextract[,-which(names(dataextract) %in% c("activityname","subjectid"))],
                     actsub=paste(dataextract$activityname, "SUBJECTID", as.character(dataextract$subjectid)))
splitactsub <- split(newdataextract[,-which(names(newdataextract)=="actsub")],newdataextract$actsub)
newdataextract <- sapply(splitactsub,colMeans,na.rm=TRUE)

## Making "newdataextract" a tidy data set

newdataextract <- as.data.frame(newdataextract)
newdataextract <- t(newdataextract)
colnames(newdataextract) <- paste("Avg",colnames(newdataextract))
newdataextract <- newdataextract[order(rownames(newdataextract)),]

## Exporting "newdataextract" to a text file named "NewTidyDataSet.txt"
  
write.table(newdataextract,"./NewTidyDataSet.txt",row.names=FALSE)

## And to a csv file named "NewTidyDataSet.csv"

write.csv(newdataextract,"./NewTidyDataSet.csv",row.names=TRUE)