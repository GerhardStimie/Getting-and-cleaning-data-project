---
title: "codebook.Rmd"
author: "Gerhard Stimie"
date: "28 November 2018"
output: 
        html_document:
          keep_md: yes
---
# Getting and cleaning data project
## Codebook detailing major data elements involved in project execution

### Source Data

This file provides metadata to support the understanding of major data elements that are used or created in this project.

The project source data can be downloaded from the following location:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The download is in the form of a zip file which needs to be unzipped (with its directory structure intact) into the "./project_data" subdirectory of the current working directory. 

The files contained in the download are:


```r
list.files("./project_data", recursive = TRUE)
```

```
##  [1] "download.zip"                                                
##  [2] "UCI HAR Dataset/activity_labels.txt"                         
##  [3] "UCI HAR Dataset/features.txt"                                
##  [4] "UCI HAR Dataset/features_info.txt"                           
##  [5] "UCI HAR Dataset/README.txt"                                  
##  [6] "UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt"   
##  [7] "UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt"   
##  [8] "UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt"   
##  [9] "UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt"  
## [10] "UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt"  
## [11] "UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt"  
## [12] "UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt"  
## [13] "UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt"  
## [14] "UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt"  
## [15] "UCI HAR Dataset/test/subject_test.txt"                       
## [16] "UCI HAR Dataset/test/X_test.txt"                             
## [17] "UCI HAR Dataset/test/y_test.txt"                             
## [18] "UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt" 
## [19] "UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt" 
## [20] "UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt" 
## [21] "UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt"
## [22] "UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt"
## [23] "UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt"
## [24] "UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt"
## [25] "UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt"
## [26] "UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt"
## [27] "UCI HAR Dataset/train/subject_train.txt"                     
## [28] "UCI HAR Dataset/train/X_train.txt"                           
## [29] "UCI HAR Dataset/train/y_train.txt"
```
The files in the "Inertial Signals" subdirectories are not used in the execution of this project as we are focussing on higher level summary data.
 
### Source data background information and metadata

The following files can be perused for information and metadata :

File                | Content
--------------------|-----------------------------------------------------------
README.txt          | General background of how the data was sourced
features_info.txt   | More detail about the 561 variables included in the test and train observation data files. The information obtained from this file will be discussed in more detail below and in the accompanying codebook that gives more detail on the data structures of the source and output files of this project.

### Source data tables used in this project

File|Content
----|----------------------|-----------------------------------------------------
./features.txt|Contains the complete list of 561 variables included in the observation vectors (rows) of the train and test observation datasets
./activity_labels.txt|Contains the 6 activity codes and descriptions used later to translate the activity codes in the observation datasets to user friendly labels
./train/y_train.txt|Contains a single column of 7352 activity codes indicating which activity was being executed by the subject/person when the the data in each of the observations in the training segment of the data population was collected.
./train/X_train.txt|This is a 7352 x 561 table where each row contains the values for each variable in a specific observation for a specific subject in the training segment of the data population.
./train/subject_train.txt|Contains a single column of 7352 subject codes indicating which subject/person the the data in each of the 7352 observations in the training segment of the data population was collected from.
./test/y_test.txt|Contains a single column of 2947 activity codes indicating which activity was being executed by the subject/person when the the data in each of the observations in the training segment of the data population was collected.
./test/X_test.txt|This is a 2947 x 561 table where each row contains the values for each variable in a specific observation for a specific subject in the training segment of the data population.
./test/subject_test.txt|Contains a single column of 2947 subject codes indicating which subject/person the the data in each of the observations in the training segment of the data population was collected from.

###Feature Vectors

The feature vectors available in the observations are:

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

Of these, we are not including the low level directional vectors (ending in X or Y or Z) in our analysis. We will therefore only work with the following feature vectors:

* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

we are only interested in the vectors for which a mean and standard deviation variable is available in the source observations. These variables are indicated by "-mean()" and "-std" appended to the vector strings above. FOr instance, we would include tBodyAccMag-mean() and tBodyAccMag-std() in our analysis if they are available in our observation data set.

From these vector names we can see that the featurs included in the strings in different combinations are:

Feature string|Description
--------------|-----------------------------------------------------------------
t or f|This indicates the domain of the measurement as either time or frequency
Body or Gravity|This indicates if the measured signal was produced by body movement or gravitational effect
Acc or Gyro|This indicates which instrument created the signa that was measured. It was either created by the Gyroscope or the Accellorometer
Jerk|If present, this indicates that the signal measured was a jerk signal. 
Mag|If present this indicates that the variable reflects the magnitude of the signal which is the net of the strength of the signal in the x, y and z directions. As this feature is common to all the feature vectors we are interested in, we leave this out of our final tidy data (as it wouldnt add any extra analysis value)

### Tidy dataset variables

The feature strings above therefore actually provide the value set of four variables that we will include in our analysis. We will add to that the mean and standard deviation variable value for the corresponding feature combination:

Variable      | Values
--------------|-----------------------------------------------------------------
domain|t,f
motioncomponent| Body, Gravity
instrument|Acc, Gyro
jearkind|Jerk, NA
mean|Real number calculated mean
stddev|Real number calculated standard deviation

We will also add to the observations two classifier variables:

Classifier    |Value
--------------|-----------------------------------------------------------------
subject|Integer between 1 and 30
activity|WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

The structure of the tidy data is given below:


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
key(tbl_tidy_obs)
```

```
## [1] "subject"         "activity"        "domain"          "motioncomponent"
## [5] "instrument"      "jerkind"
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

The file is saved to the current working directory as "tidydata.txt". A few lines from this file are:


```
"subject" "activity" "domain" "motioncomponent" "instrument" "jerkind" "mean" "stddev"
1 "WALKING_UPSTAIRS" "t" "Body" "Acc" NA -0.95943388 NA
1 "WALKING_UPSTAIRS" "t" "Body" "Acc" NA NA -0.9505515
1 "WALKING_UPSTAIRS" "t" "Body" "Acc" NA -0.97928915 NA
1 "WALKING_UPSTAIRS" "t" "Body" "Acc" NA NA -0.97605707
1 "WALKING_UPSTAIRS" "t" "Body" "Acc" NA -0.98370313 NA
1 "WALKING_UPSTAIRS" "t" "Body" "Acc" NA NA -0.98801962
1 "WALKING_UPSTAIRS" "t" "Body" "Acc" NA -0.98654176 NA
1 "WALKING_UPSTAIRS" "t" "Body" "Acc" NA NA -0.98642135
1 "WALKING_UPSTAIRS" "t" "Body" "Acc" NA -0.99282715 NA
```

### Summary data file structure

In the final step of the project, a summary file is created that calculates the mean of the two variable "mean" and "stddev" by subject, activity and feauture combination. The structure of the resulting table is:


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

 The resulting table is written to the file "summarydata.txt" in the current working directory. The first few rows of this file is listed below:



```
"subject" "activity" "domain" "motioncomponent" "instrument" "jerkind" "mean" "stddev"
1 "WALKING_UPSTAIRS" "t" "Body" "Acc" "Jerk" -0.574021004097179 -0.545989980899812
1 "WALKING_UPSTAIRS" "t" "Body" "Acc" NA -0.492214147385266 -0.531818239176489
1 "WALKING_UPSTAIRS" "t" "Body" "Gyro" "Jerk" -0.660039846322884 -0.668775141492163
1 "WALKING_UPSTAIRS" "t" "Body" "Gyro" NA -0.509087500201881 -0.525740915096552
1 "WALKING_UPSTAIRS" "t" "Gravity" "Acc" NA -0.492214147385266 -0.531818239176489
1 "WALKING_UPSTAIRS" "f" "Body" "Acc" NA -0.51451018417837 -0.618268506526646
1 "WALKING_DOWNSTAIRS" "t" "Body" "Acc" "Jerk" -0.219716752860714 -0.173363865521429
1 "WALKING_DOWNSTAIRS" "t" "Body" "Acc" NA -0.0140828025671429 -0.101515471785714
1 "WALKING_DOWNSTAIRS" "t" "Body" "Gyro" "Jerk" -0.405708505357143 -0.461512406071429
```
 

