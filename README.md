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
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set.
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

__Code Detail__


* IMPORT RAW FILES

   The following files will be imported and arranged to form a single large data set: 
      - features.txt - this will be your column names
      - X_train.txt and y_train.txt - this is the training data and activity codes respectively.
      - X_test.txt and y_test.txt - same as above but for test data
      - subject_train.txt and subject_test.txt - these are the subject IDs
      - activity_labels.txt - mapping between acitivty codes and activity labels (names)

****

   * Import variable names - features.txt
      * This file contains a single column to be inserted horizontally as column names to the consolidated dataframe/table. The column/variable names will be changed to more appropriate formats and decriptives below in this script. We'll put them in to select a subset before changing them.

****

varNames <- read.table("./features.txt", header=FALSE, 
                       colClasses="character", row.names = NULL)
#dim(varNames) # [1] 561   2 (contains row number as first column, will get 
#str(varNames)                           #rid later)
#varNames # Check data
#head(varNames)

#-------------------------------------------------------------------------
# Import training sets - X_train.txt and y_train.txt
#                        X contains the measured value
#                        y contains the activity code (mapped to activity 
#                          labels/names below in this script)
#-------------------------------------------------------------------------
xTrain <- read.table("./X_train.txt", header=FALSE)
#dim(xTrain) # [1] 7352  561
yTrain <- read.table("./y_train.txt", header=FALSE)
#dim(yTrain) # [1] 7352  1

#-------------------------------------------------------------------------
# Import test sets - descriptions same as X and y above
#-------------------------------------------------------------------------
xTest <- read.table("./X_test.txt", header=FALSE)
#dim(xTest) # [1] 2947  561
yTest <- read.table("./y_test.txt", header=FALSE)
#dim(yTest) # [1] 2947  1

#-------------------------------------------------------------------------
# Import subject sets - a one column table to map subject ID
#-------------------------------------------------------------------------
subjectTrain <- read.table("./subject_train.txt", 
                           header=FALSE)
#dim(subjectTrain) # [1] 7352    1
subjectTest <- read.table("./subject_test.txt", 
                          header=FALSE)
#dim(subjectTest) # [1] 2947    1

##############################################################################
# 1. MERGE THE TRAINING AND TEST SETS to create one data set.
##############################################################################
# Step 1. row bind (stack) the x (measurements) data sets
#-------------------------------------------------------------------------
fullData <- rbind(xTrain,xTest)

#-------------------------------------------------------------------------
# Step 2. Add column names/headers
#-------------------------------------------------------------------------
namesVec <- vector() # instantiate temp vector
namesVec <- varNames[,2] # move from data.frame to vector
names(fullData) <- namesVec # add column names to fulldata
#dim(fullData)  # [1] 10299   561

#-------------------------------------------------------------------------
# Step 3. Row bind (stack) subject sets and set column name
#-------------------------------------------------------------------------
subject <- rbind(subjectTrain,subjectTest)
names(subject) <- "Subject"
#dim(subject) # [1] 10299     1

#-------------------------------------------------------------------------
# Step 4. (Add) Column bind Subject to fulldata
#-------------------------------------------------------------------------
fullData <- cbind(fullData, subject)
#dim(fullData) # [1] 10299   562

#-------------------------------------------------------------------------
# Step 5. Row bind (stack) y sets and set variable name
#-------------------------------------------------------------------------
yData <- rbind(yTrain, yTest)
names(yData) <- "Activity"
#dim(yData) # [1] 10299     1

#-------------------------------------------------------------------------
# Step 6. Add y sets to fulldata 
#-------------------------------------------------------------------------
fullData <- cbind(fullData,yData)
#dim(fullData) # [1] 10299   563
#-- DONE! We now have a combined data set
#         with variable names across top
#str(fullData)               # Check structure of the table
#head(fullData[,1:4])         # Check small sample of data

##############################################################################
# To make things easier, use the dplyr package for 
# cleaning and tidying the rest
##############################################################################
library(dplyr)
tbl_data <- tbl_df(fullData) # put into table.frame that dplyr likes
tbl_data

##############################################################################
# Cleanup Global Environment (only tbl_data[] will be active)
##############################################################################
rm(list=c("xTrain","xTest","yTrain","yTest","subjectTrain",
          "subjectTest","namesVec","varNames","subject","yData", "fullData"))

##############################################################################
# 2. EXTRACT ONLY MEASUREMENTS on the MEAN and STANDARD DEVIATION for 
# each measurement. Only taking the triaxial data for this table.
# The magnitude values can be summarized elsewhere and added in the summary
# table.
##############################################################################

tbl_meansSd <- select(tbl_data, contains("-mean\\("), 
                               contains("-std\\("),
                               -contains("Mag"),
                               Subject, 
                               Activity)
#dim(tbl_meansSd) # [1] 10299    50
rm("tbl_data")  # Clean up environment
#colSums(is.na(tbl_meansSd)) # no missing (NA) values

##############################################################################
# 3. USE DESCRIPTIVE ACTIVITY NAMES to name the activities in the data set.
##############################################################################
# Read in activity_labels.txt: a list of six activity labels
# Add headers to match on "Activity" in the full data set
# Left join the tables to fill in the activity labels (dplyr package)
#-----------------------------------------------------------------------------
activityLabels <- read.table("./activity_labels.txt", 
                             header=FALSE)
# Add the column names so "Activity" will match "Acitivty" in the main data set
# "Activity" will be the key value
names(activityLabels) <- c("Activity","ActivityLabel")
#activityLabels # check contents

library(dplyr) # load if not currently active
# The following code maps the Activity Labels to the main data set
# Adds a new column called ActivityLabel
tbl_meansSd <- left_join(tbl_meansSd, activityLabels, by = "Activity")
#dim(tbl_meansSd) # [1] 10299    51
#head(tbl_meansSd[,50:51], 40) # Check data
tbl_meansSd %>% 
        select(Activity:ActivityLabel) %>%
        filter(Activity == 6) # Another way of checking; sub other 
                              # Activity #s if desired to confirm

##############################################################################
# 4. APPROPRIATELY LABEL THE DATA set with descriptive variable names. 
##############################################################################
# With a managebly sized table, we can take out the column/header/variable 
# names and change them to make it easier to manipulate and tidy
#-----------------------------------------------------------------------------

#tbl_meansSd # check data again
# Add an observation id number column to uniquely group each row (time entry)  
# of data before gathering/melting the data to fit tidy standards
# http://vita.had.co.nz/papers/tidy-data.pdf
tbl_meansSd$ObservationID <- 1:nrow(tbl_meansSd)
#dim(tbl_meansSd) # [1] 10299    52

# Pull out column names to clean them up and make easier to tidy
columnNames <- names(tbl_meansSd)
columnNames <- sub("\\(\\)","",columnNames) # this removes parentheses
columnNames <- sub("-","_", columnNames) # changes first dash to an underscore
                                         # to differentiate breaks
columnNames <- sub("^f","frequency\\.",columnNames) # changes leading 'f' to
                                                 # 'frequency.' Makes it easier
                                                 # to separate into other 
                                                 # column below.
columnNames <- sub("^t","time\\.",columnNames) # Same idea as for 'f' above
                                               # but for the time domain
columnNames <- sub("_mean","_Mean",columnNames) # change 'mean' to 'Mean' to
                                             # maintain naming convention
columnNames <- sub("_std","_StandardDeviation",columnNames) # change 'std' to 
                            # 'StandardDeviation' to maintain naming convention
#columnNames # Take a look
names(tbl_meansSd) <- columnNames # Replaced column names with new ones
#tbl_meansSd # Another look

##############################################################################
# MAKE A TIDY DATA SET
##############################################################################
library(tidyr) # load tidyr package for data manipulation

tbl_meansSd <- tbl_meansSd %>%      # This moves from a wide set to a tall set
        gather(MeasurementType, Measurement, -(Subject:ObservationID))
# There are now 6 variables
#dim(tbl_meansSd) # [1] 494352      6
#str(tbl_meansSd)
#------------------------------------------------------------------------------
# First step to tidy data done
#------------------------------------------------------------------------------
# Classes ‘tbl_df’, ‘tbl’ and 'data.frame':        494352 obs. of  6 variables:
# $ Subject        : int  1 1 1 1 1 1 1 1 1 1 ...
# $ Activity       : int  5 5 5 5 5 5 5 5 5 5 ...
# $ ActivityLabel  : Factor w/ 6 levels "LAYING","SITTING",..: 3 3 3 3 3 3 ...
# $ ObservationID          : int  1 2 3 4 5 6 7 8 9 10 ...
# $ MeasurementType: Factor w/ 48 levels "time.BodyAcc_Mean-X",..: 1 1 1 1 ...
# $ Measurement    : num  0.289 0.278 0.28 0.279 0.277 ...
#------------------------------------------------------------------------------
# Next separate and add 'Axis' (X, Y, and Z) column
tbl_meansSd <- tbl_meansSd %>%    
        separate(MeasurementType, into=c("Description","Axis"), sep="-")

# Next separate and add MeasurementType (Mean|StandardDeviation) column
tbl_meansSd <- tbl_meansSd %>% 
        separate(Description, into=c("Description","MeasurementType"), sep="_")

# Next separate and add Domain column for time|frequency
tbl_meansSd <- tbl_meansSd %>% # Adds Domain column for time and frequency
        separate(Description, into=c("Domain","Description"), sep="\\.")

# And finally a spread to add Mean and StandardDeviation columns for 
# each time entry. This decreases the rows by half.
tbl_meansSd <- tbl_meansSd %>%  # FINAL TIDY DATA SET OF RAW SCORES
        spread(MeasurementType, Measurement) %>%
        arrange(Subject, ObservationID, Domain, Description)

#dim(tbl_meansSd) # [1] 247176      9
#str(tbl_meansSd)
#tbl_meansSd %>% 
#        select(Description) %>%
#        unique
##############################################################################
# Final Raw Data Structure for tidy triaxial table
##############################################################################
# Classes ‘tbl_df’, ‘tbl’ and 'data.frame':        247176 obs. of  9 variables:
# $ Subject          : int  1 1 1 1 1 1 1 1 1 1 ...
# $ Activity         : int  5 5 5 5 5 5 5 5 5 5 ...
# $ ActivityLabel    : Factor w/ 6 levels "LAYING","SITTING",..: 3 3 3 3 3 3 ...
# $ ObservationID    : int  1 1 1 1 1 1 1 1 1 1 ...
# $ Domain           : chr  "frequency" "frequency" "frequency" "frequency" ...
# $ Description      : chr  "BodyAcc" "BodyAcc" "BodyAcc" "BodyAccJerk" ...
# $ Axis             : chr  "X" "Y" "Z" "X" ...
# $ Mean             : num  -0.995 -0.983 -0.939 -0.992 -0.987 ...
# $ StandardDeviation: num  -0.995 -0.983 -0.906 -0.996 -0.991 ...

##############################################################################
# 5. FROM DATA SET ABOVE, CREATE SECOND, INDEPENDENT TIDY DATA SET 
# with the average of each variable for each activity and each subject.
##############################################################################