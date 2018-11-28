---
title: "ReadMe"
author: "Gerhard Stimie"
date: "27 November 2018"
output: 
        html_document:
          keep_md: yes
---



## Coursera Specialization : Data Science - Johns Hopkins


### *Course : Getting and cleaning data*

### Course project brief

The following brief was provided to guide the end of course project execution:

>The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
>
>One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
>
>http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
>
>Here are the data for the project:
>
>https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
>
>You should create one R script called run_analysis.R that does the following.
>
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> 3. Use descriptive activity names to name the activities in the data set
> 4. Appropriately labels the data set with descriptive variable names.
> 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
>
>Good luck!

### Source Metadata

Some information files were included with the download data, Specifically the following files were perused for information:

File                | Content
--------------------|-----------------------------------------------------------
README.txt          | General background of how the data was sourced
features_info.txt   | More detail about the 561 variables included in the test and train observation data files. The information obtained from this file will be discussed in more detail below and in the accompanying codebook that gives more detail on the data structures of the source and output files of this project.

### Source data files

The following files were perused in this project (all paths are relative to the top directory (/UCI HAR Dataset) that gets created when the download file is unzipped):

File|R Table|Content
----|----------------------|-----------------------------------------------------
./features.txt|tbl_feature_labels|Contains the complete list of 561 variables included in the observation vectors (rows) of the train and test observation datasets
./activity_labels.txt|tbl_activity_labels|Contains the 6 activity codes and descriptions used later to translate the activity codes in the observation datasets to user friendly labels
./train/y_train.txt|tbl_train_activity|Contains a single column of 7352 activity codes indicating which activity was being executed by the subject/person when the the data in each of the observations in the training segment of the data population was collected.
./train/X_train.txt|tbl_test_obs|This is a 7352 x 561 table where each row contains the values for each variable in a specific observation for a specific subject in the training segment of the data population.
./train/subject_train.txt|tbl_train_subject|Contains a single column of 7352 subject codes indicating which subject/person the the data in each of the 7352 observations in the training segment of the data population was collected from.
./test/y_test.txt|tbl_test_activity|Contains a single column of 2947 activity codes indicating which activity was being executed by the subject/person when the the data in each of the observations in the training segment of the data population was collected.
./test/X_test.txt|tbl_test_obs|This is a 2947 x 561 table where each row contains the values for each variable in a specific observation for a specific subject in the training segment of the data population.
./test/subject_test.txt|tbl_test_subject|Contains a single column of 2947 subject codes indicating which subject/person the the data in each of the observations in the training segment of the data population was collected from.

### Analysis steps

#### Data preparation

Step|Action                                  |Input           |Result
----|----------------------------------------|----------------|-----------------
1|Download source data if required. Create the data directory if required and unzip source files.|Download the source data using the link to the download file specified in the project brief above.|Unzipped downloaded files in the correct data structure.
2|Read the applicable downloaded file (as discussed in the source data files section above) into the corresponding data tables|Source text files as discussed above|Corresponding R tables as discussed above
2|Read and consolidate training and test observations, subject codes and activity text files and  consolidate into consolidated observation, subject and activity tables.|rbind(tbl_train_obs,tbl_test_obs), rbind(tbl_train_activity,tbl_test_activity), rbind(tbl_train_subject,tbl_test_subject)|tbl_all_obs, tbl_all_activity, tbl_all_subject
3|Set the variable names (ie. column names) on the observation table to the respective feature text string|setnames(tbl_all_obs, tbl_feature_labels$feature_desc)|tbl_all_obs with feature strings as column names
4|Select only the mean and std deviation variables for further processing|Select from tbl_all_obs only variables with names ending in "mean()" or "std()"|tbl_selected_obs
5|Combine the selected observations with the subject and activity variable to create the final untidy(messy) table for further analysis|tbl_selected_obs,tbl_all_activity, tbl_all_subject|tbl_messy_obs

After the 5 steps summarised above, we have consolidated data table (tbl_messy_obs) containing a set means and standard deviations of feature measurements for a subject executing a specific activity. the data is untidy, because:

* Although the first 2 columns (subject and activity) indicates a singular variable, the remaining observations actually contain values for various combinations of features. I.e. the column headers actually contain multiple variable names and measures combined into 1. 


```r
str(tbl_messy_obs)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	10299 obs. of  14 variables:
##  $ subject_no             : int  2 2 2 2 2 2 2 2 2 2 ...
##  $ activity               : Factor w/ 6 levels "LAYING","SITTING",..: 4 4 4 4 4 4 4 4 4 4 ...
##  $ tBodyAccMag-mean()     : num  -0.867 -0.969 -0.976 -0.974 -0.976 ...
##  $ tBodyAccMag-std()      : num  -0.705 -0.954 -0.979 -0.977 -0.977 ...
##  $ tGravityAccMag-mean()  : num  -0.867 -0.969 -0.976 -0.974 -0.976 ...
##  $ tGravityAccMag-std()   : num  -0.705 -0.954 -0.979 -0.977 -0.977 ...
##  $ tBodyAccJerkMag-mean() : num  -0.93 -0.974 -0.982 -0.983 -0.987 ...
##  $ tBodyAccJerkMag-std()  : num  -0.896 -0.941 -0.971 -0.975 -0.989 ...
##  $ tBodyGyroMag-mean()    : num  -0.796 -0.898 -0.939 -0.947 -0.957 ...
##  $ tBodyGyroMag-std()     : num  -0.762 -0.911 -0.972 -0.97 -0.969 ...
##  $ tBodyGyroJerkMag-mean(): num  -0.925 -0.973 -0.987 -0.989 -0.99 ...
##  $ tBodyGyroJerkMag-std() : num  -0.894 -0.944 -0.984 -0.986 -0.99 ...
##  $ fBodyAccMag-mean()     : num  -0.791 -0.954 -0.976 -0.973 -0.978 ...
##  $ fBodyAccMag-std()      : num  -0.711 -0.96 -0.984 -0.982 -0.979 ...
```


#### Tidying the data

As discussed in more detail in the included code book file (codebook.html), we identified the following 8 variables occurring in the various feature strings (names(tbl_messy_obs)) above:

Variable          | Mnemonic  | Description
------------------|-----------|-------------------------------------------------
Subject|subject_no|Integer indicating the subject for whom the observation data was collected
Activity|activity|Short description of activity that the subject was executing during the collection of the observation
Domain|"t" or "f"|Indicator to indicate if the measurement is time or frequency based
Motion component|"Body" or "Gravity"|Indication if the measured motion was due to body movement or gravity effect
Instrument|"Acc" or "Gyro"|Indicates which instrument (Accelerometer or Gyroscope)
Jerk signal|"Jerk" (NA if not indicated)|Indicate if the signal measured was a jerk signal
Mean|"mean"|The mean of the measurements for the specific feature combination
Standard deviation|"std"|The standard deviation of the measurements for the specific feature combination

_Note that we are not looking at the detail direction measurements (i.e. in each of the x,y and z directions) individually. All the column names of the messy dataset contains an indicator "Mag". It is understood that the indicator implies that the measurement direction vectors have been merged into a single magnitude scalar variable (i.e the distance from the origin of the 3 dimensional space and therefore an indication of the intensity of the movement without considering the overall direction of the movement. As this indicator is common to all the feature combinations in our selected observation table, this indicator has been ignored in the creation of our tidy dataset._


The appoached followed in tidying the data, is to create an empty table (tbl_tidy_obs) with a column for each of the 8 variables identified above. We can also calculate the mumber of rows that our final tidy table will have since it will contain a row for each of the feature string columns (i.e. all columns but the first 2) that we will parse into a new (tidy) observation in the tidy dataset we are collating. 

Therefore the number of rows needed in our tidy dataset can be calculated as follows:

> tidy rows = (number of messy rows) x ((number messy columns) - 2)

_We do not need to parse the subject and activity columns. So we will only have a new row in the tidy dataset for each of the feature combination columns.. with the subject and activity columns repeated for every new tidy row parsed from every messy row column (feature combination)._

The column names to be used for our tidy dataset (tbl_tidy_obs) are:


```
## [1] "subject"         "activity"        "domain"          "motioncomponent"
## [5] "instrument"      "jerkind"         "mean"            "stddev"
```

#### Data tidying steps

Step|Action                                  |Input           |Result
----|----------------------------------------|----------------|-----------------
1|Create empty data table to receive the tidy observation rows resulting from parsing the columns of the messy data table and set the column names to the names of the tidy variables as discussed above.|nrow(tbl_messy_obs) ncol(tbl_messy_obs)|tbl_tidy_obs (empty)
2|Create list object wkth the same structure as a single row of the tidy dataset||rowlist (empy list with same structure as a tidy data row)
3|Parse the messy data table by row and column and populate the approriate rowlist item with the variable value (see codebook.html for detail). When all variables of the rowlist have been populated, save the rowlist to the appropriate row in the tidy data table.|tbl_messy_obs|rowlist(populated for every iteration of the parsing loop), tbl_tidy_obs
4|Write the tidy dataset to the current working directory folder|tbl_tidy_obs|"tidydata.txt" file in working directory folder.

The tidying process produces a clean data table tbl_tidy_obs.


```r
str(tbl_tidy_obs)
```

```
## Classes 'data.table' and 'data.frame':	123588 obs. of  8 variables:
##  $ subject        : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity       : Factor w/ 6 levels "WALKING","WALKING_UPSTAIRS",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ domain         : Factor w/ 2 levels "t","f": 1 1 1 1 1 1 1 1 1 1 ...
##  $ motioncomponent: Factor w/ 2 levels "Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
##  $ instrument     : Factor w/ 2 levels "Acc","Gyro": 1 1 1 1 1 1 1 1 1 1 ...
##  $ jerkind        : Factor w/ 1 level "Jerk": NA NA NA NA NA NA NA NA NA NA ...
##  $ mean           : num  -0.959 NA -0.979 NA -0.984 ...
##  $ stddev         : num  NA -0.951 NA -0.976 NA ...
##  - attr(*, ".internal.selfref")=<externalptr> 
##  - attr(*, "sorted")= chr  "subject" "activity" "domain" "motioncomponent" ...
```

```r
head(tbl_tidy_obs)
```

```
##    subject         activity domain motioncomponent instrument jerkind
## 1:       1 WALKING_UPSTAIRS      t            Body        Acc    <NA>
## 2:       1 WALKING_UPSTAIRS      t            Body        Acc    <NA>
## 3:       1 WALKING_UPSTAIRS      t            Body        Acc    <NA>
## 4:       1 WALKING_UPSTAIRS      t            Body        Acc    <NA>
## 5:       1 WALKING_UPSTAIRS      t            Body        Acc    <NA>
## 6:       1 WALKING_UPSTAIRS      t            Body        Acc    <NA>
##          mean     stddev
## 1: -0.9594339         NA
## 2:         NA -0.9505515
## 3: -0.9792892         NA
## 4:         NA -0.9760571
## 5: -0.9837031         NA
## 6:         NA -0.9880196
```

```r
tail(tbl_tidy_obs)
```

```
##    subject activity domain motioncomponent instrument jerkind       mean
## 1:      30   LAYING      f            Body        Acc    <NA> -0.2986540
## 2:      30   LAYING      f            Body        Acc    <NA>         NA
## 3:      30   LAYING      f            Body        Acc    <NA> -0.3467948
## 4:      30   LAYING      f            Body        Acc    <NA>         NA
## 5:      30   LAYING      f            Body        Acc    <NA> -0.2400381
## 6:      30   LAYING      f            Body        Acc    <NA>         NA
##        stddev
## 1:         NA
## 2: -0.2202881
## 3:         NA
## 4: -0.2345385
## 5:         NA
## 6: -0.3426704
```

### Summarise tidy data

The last step required by the project brief is to create a new tidy data table that calculated the mean of the "mean" and "stddev" columns of the tidy dataset for every subject and activity and for each applicable feature combination.

The R code used to execute this is:


```r
tbl_summary <- tbl_tidy_obs %>%
         group_by(subject,
                  activity,
                  domain, 
                  motioncomponent, 
                  instrument,
                  jerkind 
                 ) %>%
         summarise_all(mean,na.rm=TRUE)
```

The resulting table is overviewed below:


```r
str(tbl_summary)
```

```
## Classes 'grouped_df', 'tbl_df', 'tbl' and 'data.frame':	210 obs. of  8 variables:
##  $ subject        : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity       : Factor w/ 6 levels "WALKING","WALKING_UPSTAIRS",..: 2 2 2 2 2 2 3 3 3 3 ...
##  $ domain         : Factor w/ 2 levels "t","f": 1 1 1 1 1 2 1 1 1 1 ...
##  $ motioncomponent: Factor w/ 2 levels "Body","Gravity": 1 1 1 1 2 1 1 1 1 1 ...
##  $ instrument     : Factor w/ 2 levels "Acc","Gyro": 1 1 2 2 1 1 1 1 2 2 ...
##  $ jerkind        : Factor w/ 1 level "Jerk": 1 NA 1 NA NA NA 1 NA 1 NA ...
##  $ mean           : num  -0.574 -0.492 -0.66 -0.509 -0.492 ...
##  $ stddev         : num  -0.546 -0.532 -0.669 -0.526 -0.532 ...
##  - attr(*, ".internal.selfref")=<externalptr> 
##  - attr(*, "sorted")= chr  "subject" "activity" "domain" "motioncomponent" ...
##  - attr(*, "vars")= chr  "subject" "activity" "domain" "motioncomponent" ...
##  - attr(*, "drop")= logi TRUE
```

```r
head(tbl_summary)
```

```
## # A tibble: 6 x 8
## # Groups:   subject, activity, domain, motioncomponent, instrument [4]
##   subject activity domain motioncomponent instrument jerkind   mean stddev
##     <dbl> <fct>    <fct>  <fct>           <fct>      <fct>    <dbl>  <dbl>
## 1       1 WALKING~ t      Body            Acc        Jerk    -0.574 -0.546
## 2       1 WALKING~ t      Body            Acc        <NA>    -0.492 -0.532
## 3       1 WALKING~ t      Body            Gyro       Jerk    -0.660 -0.669
## 4       1 WALKING~ t      Body            Gyro       <NA>    -0.509 -0.526
## 5       1 WALKING~ t      Gravity         Acc        <NA>    -0.492 -0.532
## 6       1 WALKING~ f      Body            Acc        <NA>    -0.515 -0.618
```

```r
tail(tbl_summary)
```

```
## # A tibble: 6 x 8
## # Groups:   subject, activity, domain, motioncomponent, instrument [4]
##   subject activity domain motioncomponent instrument jerkind   mean stddev
##     <dbl> <fct>    <fct>  <fct>           <fct>      <fct>    <dbl>  <dbl>
## 1      30 LAYING   t      Body            Acc        Jerk    -0.697 -0.659
## 2      30 LAYING   t      Body            Acc        <NA>    -0.538 -0.588
## 3      30 LAYING   t      Body            Gyro       Jerk    -0.786 -0.810
## 4      30 LAYING   t      Body            Gyro       <NA>    -0.510 -0.574
## 5      30 LAYING   t      Gravity         Acc        <NA>    -0.538 -0.588
## 6      30 LAYING   f      Body            Acc        <NA>    -0.600 -0.647
```

The file is written to the file "summarydata.txt" in the current working directory.

### Peer review information

The project files are available on the Github repository:

https://github.com/GerhardStimie/Getting-and-cleaning-data-project

Files in the repository related to the review are:

File         |Content
-------------|------------------------------------------------------------------
run_analysis.R|The script for the execution of the project. The full project execution is contained in this script. There are no other scripts required for execution.
Readme.html|The readme file for the project
Codebook.html|The codebook provides meta data on the input and output data used and created by the script.
messydata.txt|The consolidated observations file collated from the various source files
tidydata.txt|The final tidy data table created by the script
summarydata.txt|The tidy data table after the summary process as per the project brief.

### How to execute the peer review 

To execute the script, you need to:

1. Download the file from the Git directory
2. Save it in a local directory on your computer that you can use as a working directory in Rstudio, 
3. You then need to edit the path of the working directory in the script
4. The script will create a sub-directory "project_data" in the working directory if it doesnt exist.
5. The script will download the source data and unzip it into the "./project_data" sub-directory.
6. Running the script will create the files "messydata.txt", "tidydata.txt" and "summarydata.txt" in the working directory for review. The same files are also available in the Github repository (path above) 

