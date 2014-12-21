GettingAndCleaningData
======================

Getting and Cleaning Data Course Project - description of particular blocks within run_analysis.R file:

###1. preparation of TEST data:
read data sets into data frames
* reading all sets needed for coursera project with use of read.table() function
* additional block for reading inertial signals files (not necessary for 
cousera project but just in case to have all data together)
  * using list.files() function to read file names inertial signals data with 
directories
  * using for loop to process all files (read and rename)
  * using another internal for loop rename all 128 variables within the inertial signals files with similar pattern

modify particular data frames
* apply features name from features.txt to x_test data frame 
* rename subject number as subject_id in subject_test data frame
* add activity label to y_test data frame
* bind all modified data frames into one test data frame

###2. preparation of TRAIN data - the same process performed that on TEST data, including:
* read data sets ito data frames
* modify particular data frames 

###3. binding both sets: train and test
* creating final data frame as union of test and train data frames (rbind() function)

###4. limiting variables in final data frame to: subject & activity identifiers and mean & standard deviation characteristics
* using regular patterns to match expected variables

### 5. calculation of average of each variable for each activity and each subject
* using  for loop and aggregate() function to prepare needed mean calculation 
per subject and activity
* adding one by one calculated means to new data frame 

### 6. final tuning of variables names to exclude "()" and "-"
* using gsub() function and regular patterns to rename variables  

### 7. displaying output
* using view() function to open final3 data frame
* similarly displaying data frame in console
