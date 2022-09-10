# GettingCleaningDataProject
Code Book

========================================

I. Source data

The script downloads/ unzips data and reads in the data components to the following tables:

- "trainset": Training set,numeric values, normalised and bounded within [-1,1]
- "trainnames": Training [activity] labels, numeric values 1-6
- "trainsubjects" ID of subjects who performed the activity, numeric values 1-30

- "testset": Test set, numeric values, normalised and bounded within [-1,1]
- "testnames": Test [activity] labels, numeric values 1-6
- "testsubjects": ID of subjects who performed the activity, numeric values 1-30

- "activitynames": List of [descriptive] activity names, 6 distinct character values 
- "features": List of feature names, 561 distinct character values

The script adds character class variable "originalset" with values "training" and "test", as indicator of the original set.

========================================

II. Analysis

The script follows the analysis steps as per Project Assignment instructions:

1. Merges the training and the test sets to create one data set: "mergedset".

2. Extracts only the measurements on the mean and standard deviation for each measurement, to "dataextract".

Note:
- Such measurements are identified as having "-mean()" or "-std()"in the feature name, where feature names are specified in the second column of the "features" table,
- The extract also includes "activityid" and "subjectid" variables,
- The variable "originalset"" is dropped in the extract.

3. Uses descriptive activity names to name the activities in the data set

The script applies "split & apply" technique to the variable "activityid".
The resulting set has activity name value where previously there was ID.

4. Appropriately labels the data set with descriptive variable names.

- Feature names are used as variable names,
- "activityid" variable name is replaced with "activityname", in line with the earlier step,
- "subjectid" variable name remains unchanged.

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

- Second, independent tidy data set: "newdataextract", is created from the earlier data extract by replacing original variables "activityname" and "subjectid", with a variable "actsub" that concatenates activity name and subject id Into a unique identifier.
- The script again applies "split & apply" technique to the new identifier variable "actsub", with function colMeans applied for all remaining (feature) variables to obtain feature averages.
- The script performs additional formatting steps to ensure data is tidy, in particular:
  (i) Transposing rows and columns, so that activity/ subject identifiers are rows, and feature averages are columns,
  (ii) Updating column names with a prefix "Avg" to reflect that the variables are feature averages (not individual feature measurements).

========================================

III. Output dataset

The cecond, independent tidy data set "newdataextract" is exported to txt file "NewTidyDataSet.txt".
And, to a csv file "NewTidyDataSet.csv".