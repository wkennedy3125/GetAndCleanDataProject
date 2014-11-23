Code Book for Getting and Cleaning Data Project
====================


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
