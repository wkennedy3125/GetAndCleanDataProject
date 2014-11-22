# run_analysis.R
# Getting and Cleaning Data Course Project code
# 
#setwd("/Users/adakemia/Documents/Academic/Coursera/DataScienceSpecialization/03GettingAndCleaningData/Project/GetAndCleanDataProject")
#getwd()
##############################################################################
# IMPORT RAW FILES
#                   The following files will be imported and arranged to form
#                   a single large data set: 
#                       1. features.txt
#                       2. X_train.txt and y_train.txt
#                       3. X_test.txt and y_test.txt
#                       4. subject_train.txt and subject_test.txt
##############################################################################
# IMPORT VARIABLE NAMES - features.txt
#                         This file contains a single column to be inserted 
#                         horizontally as column names to the consolidated 
#                         file. 
#-------------------------------------------------------------------------
varNames <- read.table("../UCI HAR Dataset/features.txt", header=FALSE, 
                       colClasses="character", row.names = NULL)
dim(varNames) # [1] 561   2 (contains row number as first column)
str(varNames)

# IMPORT TRAINING SETS - X_train.txt and y_train.txt
#-------------------------------------------------------------------------
xtrain <- read.table("../UCI HAR Dataset/train/X_train.txt", header=FALSE)
dim(xtrain) # [1] 7352  561
ytrain <- read.table("../UCI HAR Dataset/train/y_train.txt", header=FALSE)
dim(ytrain) # [1] 7352  1

# IMPORT TEST SETS
#-------------------------------------------------------------------------
xtest <- read.table("../UCI HAR Dataset/test/X_test.txt", header=FALSE)
dim(xtest) # [1] 2947  561
ytest <- read.table("../UCI HAR Dataset/test/y_test.txt", header=FALSE)
dim(ytest) # [1] 2947  1

# IMPORT SUBJECT SETS
#-------------------------------------------------------------------------
subjecttrain <- read.table("../UCI HAR Dataset/train/subject_train.txt", 
                           header=FALSE)
dim(subjecttrain) # [1] 7352    1
subjecttest <- read.table("../UCI HAR Dataset/test/subject_test.txt", 
                          header=FALSE)
dim(subjecttest) # [1] 2947    1

##############################################################################
# MERGE the training and the test sets to create one data set.
##############################################################################
# Step 1. row bind (stack) the x data sets
#-------------------------------------------------------------------------
fulldata <- rbind(xtrain,xtest)

# Step 2. Add variable names to x set
#-------------------------------------------------------------------------
namesVec <- vector() # instantiate temp vector
namesVec <- varNames[,2] # move from data.frame to vector
names(fulldata) <- namesVec # add variable names to fulldata for x sets
dim(fulldata)  # [1] 10299   561

# Step 3. Row bind (stack) subject sets and set column name
#-------------------------------------------------------------------------
subject <- rbind(subjecttrain,subjecttest)
names(subject) <- "Subject"
dim(subject) # [1] 10299     1

# Step 4. (Add) Column bind Subject to fulldata
#-------------------------------------------------------------------------
fulldata <- cbind(fulldata, subject)
dim(fulldata) # [1] 10299   562

# Step 5. Row bind (stack) y sets and set variable name
#-------------------------------------------------------------------------
ydata <- rbind(ytrain, ytest)
names(ydata) <- "Activity"
dim(ydata) # [1] 10299     1

# Step 6. Add y sets to fulldata 
#-------------------------------------------------------------------------
fulldata <- cbind(fulldata,ydata)
dim(fulldata) # [1] 10299   563
#-- DONE! We now have a combined data set
#         with variable names across top
str(fulldata)               # Check structure of the table
head(fulldata[,1:4])         # Check small sample of data
##############################################################################
# To make things easier, use the dplyr package for 
# cleaning and tidying the rest
##############################################################################
library(dplyr)
tbl_data <- tbl_df(fulldata)
tbl_data
##############################################################################
# Cleanup Global Environment (only tbl_data[] will be active)
##############################################################################
rm(list=c("xtrain","xtest","ytrain","ytest","subjecttrain",
          "subjecttest","namesVec","varNames","subject","ydata", "fulldata"))

##############################################################################
# EXTRACT only the measurements on the MEAN and STANDARD DEVIATION for 
# each measurement. 
##############################################################################

tbl_meansd <- select(tbl_data, contains("-mean\\("), 
                               contains("-std\\("), 
                               Subject, 
                               Activity)
dim(tbl_meansd) # [1] 10299    68
rm("tbl_data")  # Clean up environment
colSums(is.na(tbl_meansd)) # no missing (NA) values

##############################################################################
# Use descriptive activity names to name the activities in the data set.
##############################################################################
filter(tbl_meansd, Subject == 1)

##############################################################################
# Appropriately label the data set with descriptive variable names. 
##############################################################################



##############################################################################
# From the data set above, create a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
##############################################################################




