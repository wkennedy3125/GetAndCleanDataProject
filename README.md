GetAndCleanDataProject
======================

## Course project for JH's DataScience Track 'Getting and Cleaning Data'

### Project Description

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

### Deliverables

* a tidy data set as described below, 
* a link to a Github repository with your script for performing the analysis called run_analysis.R (see below)
* a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md
* a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

### run_analysis.R 

__Brief Summary__

****

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set.
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

****

__Code Detail__

****

Step 0. IMPORT RAW FILES

****

The following files will be imported and arranged to form a single large data set: 
- features.txt - this will be your column names
- X_train.txt and y_train.txt - this is the training data and activity codes respectively.
- X_test.txt and y_test.txt - same as above but for test data
- subject_train.txt and subject_test.txt - these are the subject IDs
- activity_labels.txt - mapping between acitivty codes and activity labels (names)

****

Import variable names - 
* features.txt

This file contains a single column to be inserted horizontally as column names to the consolidated dataframe/table. The column/variable names will be changed to more appropriate formats and descriptives below in this script. We'll put them in to select a subset before changing them.

****

Import training sets - 
* X_train.txt and y_train.txt
   * X contains the measured value
   * y contains the activity code (mapped to activity labels/names below in this script)

****

Import test sets - descriptions same as X and y above
* X_test.txt and y_test.txt

****

Import subject sets - a one column table to map subject ID
* subject.txt

****

 Step 1. MERGE THE TRAINING AND TEST SETS to create one data set.

****

* Row bind (stack) the x (measurements) data sets
* Add column names/headers
* Row bind (stack) subject sets and set column name
* (Add) Column bind Subject to fulldata
* Row bind (stack) y sets and set variable name
* Add y sets to fulldata 

****

 To make things easier, use the dplyr package for 
 cleaning and tidying the rest

****

Cleanup Global Environment (only tbl_data[] will be active)

****

 Step 2. EXTRACT ONLY MEASUREMENTS on the MEAN and STANDARD DEVIATION

****

Only taking the triaxial data for this table.
The magnitude values can be summarized elsewhere and added in the summary table.

Use the dplyr `select()` function

****

 Step 3. USE DESCRIPTIVE ACTIVITY NAMES to name the activities in the data set.

****

* Read in activity_labels.txt: a list of six activity labels
* Add column names to match on "Activity" in the full data set
* Left join the tables to fill in the activity labels (dplyr package, `left_join()`)
   * Add the column names so "Activity" will match "Activity" in the main data set
   * ”Activity" will be the key value
   * Adds a new column called ActivityLabel

****

 Step 4. APPROPRIATELY LABEL THE DATA set with descriptive variable names. 

****

 With a manageably sized table, we can take out the column/header/variable 
 names and change them to make it easier to manipulate and tidy

****

 Add an observation id number column to uniquely group each row (time entry)  
 of data before gathering/melting the data to fit tidy standards

 http://vita.had.co.nz/papers/tidy-data.pdf

****

Pull out column names to clean them up and make it easier to manage.

The variables currently look like:
* tBodyAcc-mean()-Z
* tBodyAcc-std()-X

1. Remove parentheses 
2. Change first dash to an underscore to differentiate breaks
3. Change leading 'f' to 'frequency.' Makes it easier to separate into other column below.
4. Change leading ’t’ to ‘time’ 
5. Change 'mean' to 'Mean' to maintain naming convention
6. Change 'std' to 'StandardDeviation' to maintain naming convention
7. Replace column names with new ones

****

 MAKE A TIDY DATA SET

****

* load tidyr package for data manipulation
* Use the `gather()` function to move from a wide set to a tall set 
* There are now 6 variables

****

 First step to tidy data done

****

Classes ‘tbl_df’, ‘tbl’ and 'data.frame':        494352 obs. of  6 variables:
 - Subject        : int  1 1 1 1 1 1 1 1 1 1 ...
 - Activity       : int  5 5 5 5 5 5 5 5 5 5 ...
 - ActivityLabel  : Factor w/ 6 levels "LAYING","SITTING",..: 3 3 3 3 3 3 ...
 - ObservationID          : int  1 2 3 4 5 6 7 8 9 10 ...
 - MeasurementType: Factor w/ 48 levels "time.BodyAcc_Mean-X",..: 1 1 1 1 ...
 - Measurement    : num  0.289 0.278 0.28 0.279 0.277 ...

****

Next 
* `separate()` and add 'Axis' (X, Y, and Z) column
* `separate()` and add MeasurementType (Mean|StandardDeviation) column
* `separate()` and add Domain column for time|frequency
* And finally a `spread()` to add Mean and StandardDeviation columns for each time entry. 
   * This decreases the rows by half.

****

 Final Raw Data Structure for tidy triaxial table (See CodeBook.md)

****

 Classes ‘tbl_df’, ‘tbl’ and 'data.frame':        247176 obs. of  9 variables:
 - Subject          : int  1 1 1 1 1 1 1 1 1 1 ...
 - Activity         : int  5 5 5 5 5 5 5 5 5 5 ...
 - ActivityLabel    : Factor w/ 6 levels "LAYING","SITTING",..: 3 3 3 3 3 3 ...
 - ObservationID    : int  1 1 1 1 1 1 1 1 1 1 ...
 - Domain           : chr  "frequency" "frequency" "frequency" "frequency" ...
 - Description      : chr  "BodyAcc" "BodyAcc" "BodyAcc" "BodyAccJerk" ...
 - Axis             : chr  "X" "Y" "Z" "X" ...
 - Mean             : num  -0.995 -0.983 -0.939 -0.992 -0.987 ...
 - StandardDeviation: num  -0.995 -0.983 -0.906 -0.996 -0.991 ...

****

 Step 5. FROM DATA SET ABOVE, CREATE SECOND, INDEPENDENT TIDY DATA SET 
 with the average of each variable for each activity and each subject.

****