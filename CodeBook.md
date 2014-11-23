Code Book for Getting and Cleaning Data Project
====================

This codebook lists two sets of dataset variables:

1. A narrowly structured raw data set with 9 variables [247176 X 9]
2. A narrowly structured summary data set with 7 variables [2700 X 7]

These sets are based on the raw data available from:

UCI Machine Learning Repository  
Center for Machine Learning and Intelligent Systems  
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

When arranged these data are a wide formatted set with 561 variables [10299 X 561]

The variable transformations are shown in Appendix 1 (below)

****
Information from the website on the data source:

>The experiments have been carried out with a group of 30 volunteers within an age bracket >of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, >WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) >on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear >acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments >have been video-recorded to label the data manually. The obtained dataset has been >randomly partitioned into two sets, where 70% of the volunteers was selected for >generating the training data and 30% the test data.  

>   The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise >filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 >readings/window). The sensor acceleration signal, which has gravitational and body motion >components, was separated using a Butterworth low-pass filter into body acceleration and >gravity. The gravitational force is assumed to have only low frequency components, >therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of >features was obtained by calculating variables from the time and frequency domain.  

A README.txt file (not the one in this repository) with further details is included with the datasets. 

****

## Cleaned and arranged raw data file variables (9 variables)
(Summary table list is below)

### Subject
* __length__: 2
* __type__: integer
* __values__: 1 - 30
* __description__: Identification of measurement taker

**** 

### Activity
* __length__: 1
* __type__: integer
* __values__: 1 - 6
* __description__: Activity code. A value from one to six specifying the activity

****

### ActivityLabel
* __length__: 18
* __type__: factor / 6 levels
* __values__:

   * WALKING
   * WALKING_UPSTAIRS
   * WALKING_DOWNSTAIRS
   * SITTING
   * STANDING
   * LAYING

* __description__: The names for the activities mapping to the activity (numbers)

****

### ObservationID
* __length__: 5
* __type__: integer
* __values__: 1 - [the number of rows in the raw data set] > 10,000
* __description__: A unique identifier for each observational row in the original data

****

### Domain
* __length__: 9
* __type__: character
* __values__: 
   * time
   * frequency
* __description__: These indicate the time or frequency domain of the measurement

****

### Description
* __length__: 20
* __type__: character
* __values__:
   * BodyAcc : Body Acceleration
   * BodyAccJerk : Body Acceleration Jerk
   * BodyGyro : Body Gyroscopic
   * BodyGyroJerk : Body Gyroscopic Jerk
   * GravityAcc : Gravity Acceleration
* __description__: Description of type of signal measured

****

### Axis
* __length__: 1
* __type__: character
* __values__: 
   * X
   * Y
   * Z
* __description__: Indicates the axis of measurement

****

### Mean
* __length__: 10
* __type__: numeric
* __values__: -x.xxxxxxx - x.xxxxxxx
* __description__: The mean of each measurement observation

****

### StandardDeviation
* __length__: 10
* __type__: numeric
* __values__: -x.xxxxxxx - x.xxxxxxx
* __description__: The standard deviation of each measurement observation

****

## Summary table list of variables (7 variables)

### Subject
* __length__: 2
* __type__: integer
* __values__: 1 - 30
* __description__: Identification of measurement taker

**** 

### ActivityLabel
* __length__: 18
* __type__: factor / 6 levels
* __values__:

   * WALKING
   * WALKING_UPSTAIRS
   * WALKING_DOWNSTAIRS
   * SITTING
   * STANDING
   * LAYING

* __description__: The names for the activities mapping to the activity (numbers)

****

### Description
* __length__: 20
* __type__: character
* __values__:
   * BodyAcc : Body Acceleration
   * BodyAccJerk : Body Acceleration Jerk
   * BodyGyro : Body Gyroscopic
   * BodyGyroJerk : Body Gyroscopic Jerk
   * GravityAcc : Gravity Acceleration
* __description__: Description of type of signal measured

****

### Axis
* __length__: 1
* __type__: character
* __values__: 
   * X
   * Y
   * Z
* __description__: Indicates the axis of measurement

****

### Count
* __length__: 3
* __type__: integer
* __values__: 1 - 999
* __description__: Number of summarized observations

****

### AverageMean
* __length__: 10
* __type__: numeric
* __values__: -x.xxxxxxx - x.xxxxxxx
* __description__: The mean of means of all measurement observations

****

### AverageStandardDeviation
* __length__: 10
* __type__: numeric
* __values__: -x.xxxxxxx - x.xxxxxxx
* __description__: The mean standard deviation of all measurement observations

****

****

### APPENDIX 1

****

__Variable Transformation__

The variables in the original raw data sets look like:  
* tBodyAcc-mean()-Z
* fBodyAcc-std()-X
* etc.

Information is contained within the variable name  
* time vs. frequency domain
* signal description (e.g., Body Acceleration, Body Jerk)
* measurement type (mean | std)
* axis (X, Y, or Z)

This way of organizing the variables yields a wide dataset and does not conform to the “tidy data” principles proposed by Hadley Wickham  
(http://vita.had.co.nz/papers/tidy-data.pdf)  

   The R packages, dplyr and tidyr, were used to separate this information and transform these variables to the above narrow data structure. This narrow structure might provide more flexible arrangement and filtering opportunities.