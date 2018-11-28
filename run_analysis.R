##This script does the following:
##
## 1.   Merges the training and the test sets to create one data set.
## 2.   Extracts only the measurements on the mean and standard deviation for 
##      each measurement.
## 3.   Uses descriptive activity names to name the activities in the data set
## 4.   Appropriately labels the data set with descriptive variable names.
## 5.   From the data set in step 4, creates a second, independent tidy data set 
##      with the average of each variable for each activity and each subject.

################################################################################
################################################################################
##                                                                            ##
##      Set project and data directory paths.                                 ##
##                                                                            ##
## TO TEST THIS SCRIPT IN A DIFFERENT ENVIRONMENT, CHANGE THE DIRECTORY       ##
## PATHS BELOW TO VALID VALUES FOR THE ENVIRONMENT WHERE THE SCRIPT IS TO     ##
## BE EXECUTED (TESTED)                                                       ##
##                                                                            ##
################################################################################
################################################################################

project_dir <- paste("~/Data Science/Data Science Specialisation - Coursera",
                     "/Course 3 - Processing Raw data",
                     "/Repo",
                     "/Getting-and-cleaning-data-Project", sep = "")

data_dir <- "./project_data"

################################################################################
################################################################################

## Make the required R packages available for this script to execute

library(data.table)
library(dplyr)
library(lubridate)

##      Set working directory to the project directory specified above

setwd(project_dir)

##      Create data directory if it doesnt exist.

if (!file.exists(data_dir)){
        dir.create(paste("./", data_dir, sep = ""))
}


## set the paths to the required source data files

har_dir <- paste(data_dir, "/UCI HAR Dataset", sep = "")
train_dir <- paste(har_dir, "/train", sep = "")
test_dir <- paste(har_dir, "/test", sep = "")
activity_labels_file <- paste(har_dir, "/activity_labels.txt", sep = "")
feature_labels_file <- paste(har_dir, "/features.txt", sep = "")
train_subject_file <- paste(train_dir, "/subject_train.txt", sep = "")
train_activity_file <- paste(train_dir, "/y_train.txt", sep = "")
train_obs_file <- paste(train_dir, "/X_train.txt", sep = "")
test_subject_file <- paste(test_dir, "/subject_test.txt", sep = "")
test_activity_file <- paste(test_dir, "/y_test.txt", sep = "")
test_obs_file <- paste(test_dir, "/X_test.txt", sep = "")

##
## Download and unzip the project source data if it is not already
## in the data directory as stipulated above
##


if (!file.exists(har_dir)) {
        filepath <- paste("https://d396qusza40orc.cloudfront.net",
                          "/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                          sep = "")
        dest_file <- paste(data_dir, "/download.zip", sep = "")
        download.file(filepath,dest_file,method = "curl")
        unzip(dest_file,exdir = data_dir, overwrite = TRUE)
}

## Load activity translation table 
## (used to tranlsate activity codes to activity descriptions.)

tbl_activity_labels <- fread(input = activity_labels_file,
                             header = FALSE,
                             stringsAsFactors = FALSE,
                             col.names = (c("activity_no", "activity_name"))
)
tbl_activity_labels <- tbl_df(tbl_activity_labels)

## Load feature labels table 
## (used as column names in the observation tables below.)

tbl_feature_labels <- fread(input = feature_labels_file,
                            header = FALSE,
                            stringsAsFactors = FALSE,
                            col.names = (c("feature_no", "feature_desc"))
)
tbl_feature_labels <- tbl_df(tbl_feature_labels)

## load training datasets

tbl_train_activity <- fread(input = train_activity_file,
                            header = FALSE,
                            stringsAsFactors = FALSE,
                            col.names = "activity_no"
)
tbl_train_activity <- tbl_df(tbl_train_activity)

tbl_train_subject <- fread(input = train_subject_file,
                           header = FALSE,
                           stringsAsFactors = FALSE,
                           col.names = "subject_no"
)
tbl_train_subject <- tbl_df(tbl_train_subject)

tbl_train_obs <- fread(input = train_obs_file,
                       header = FALSE,
                       stringsAsFactors = FALSE
)
tbl_train_obs <- tbl_df(tbl_train_obs)


## Load Test datasets and convert to 

tbl_test_activity <- fread(input = test_activity_file,
                           header = FALSE,
                           stringsAsFactors = FALSE,
                           col.names = "activity_no"
)
tbl_test_activity <- tbl_df(tbl_test_activity)

tbl_test_subject <- fread(input = test_subject_file,
                          header = FALSE,
                          stringsAsFactors = FALSE,
                          col.names = "subject_no"
)
tbl_test_subject <- tbl_df(tbl_test_subject)

tbl_test_obs <- fread(input = test_obs_file,
                      header = FALSE,
                      stringsAsFactors = FALSE
)
tbl_test_obs <- tbl_df(tbl_test_obs)

##
## Merge all test and training observation tables into a single corresponding 
## tables by appending the rows of the test and train observation, subject and 
## activity tables to new tables containing all the values. Remove reduntant 
## tables to preserve memory
##

tbl_all_obs <- rbind(tbl_test_obs, tbl_train_obs)
tbl_all_subject <- rbind(tbl_test_subject, tbl_train_subject)
tbl_all_activity <- rbind(tbl_test_activity, tbl_train_activity)



##
## Set the column names in the combined observation table to the 
## corresponding feature names using the feature names table as column names
##

setnames(tbl_all_obs, tbl_feature_labels$feature_desc)


##
## Select only the observations for which the column names contain "mean()
## or std()
##

tbl_selected_obs <- tbl_all_obs[, grepl("*mean\\(\\)$|*std\\(\\)$", 
                                        names(tbl_all_obs))>0]
##
##As we are only interested in variables giving us values for combinations of
##single instances of each feature, we exclude variables containing "BodyBody"
##

tbl_selected_obs <- tbl_selected_obs[, grepl("BodyBody", 
                                             names(tbl_selected_obs))<=0]

## 
## Combine the selected observations, subject table and activity table to
## identify the subject and activity to which a specific observation applies.
## This gives us the final messy data table that we will tidy

tbl_all_activity_desc <- merge(tbl_all_activity, tbl_activity_labels)

tbl_messy_obs <- cbind(tbl_all_subject, tbl_all_activity_desc$activity_name,
                       tbl_selected_obs
)
##
## Fix the column name for the "activity" column
##

names(tbl_messy_obs)[2] <- "activity"

tbl_messy_obs <- tbl_df(tbl_messy_obs)

write.table(tbl_messy_obs,"messydata.txt", row.names = FALSE)

## remove redundant input data tables to release memory


#rm("tbl_test_obs",
#   "tbl_train_obs", 
#   "tbl_train_subject", 
#   "tbl_test_subject",
#   "tbl_test_activity",
#   "tbl_train_activity",
#   "tbl_all_activity",
#   "tbl_all_activity_desc",
#   "tbl_all_obs",
#   "tbl_all_subject",
#   "tbl_feature_labels",
#   "tbl_selected_obs",
#   "tbl_activity_labels"
#)

## Tidy data

obs_colnames <- c("subject",
                    "activity",
                    "domain", 
                    "motioncomponent", 
                    "instrument",
                    "jerkind", 
                    "mean",
                    "stddev"
                    )

nobs <- nrow(tbl_messy_obs[,1])
nvar <- ncol(tbl_messy_obs)

maxrows <- nobs*(nvar-2)

varname <- names(tbl_messy_obs)

tbl_tidy_obs <- data.table(matrix(ncol = 8, nrow = maxrows))
names(tbl_tidy_obs) <- obs_colnames

tbl_tidy_obs$subject <- as.numeric(tbl_tidy_obs$subject)
tbl_tidy_obs$activity <- as.factor(tbl_tidy_obs$activity)
tbl_tidy_obs$domain <- as.factor(tbl_tidy_obs$domain)
tbl_tidy_obs$motioncomponent <- as.factor(tbl_tidy_obs$motioncomponent)
tbl_tidy_obs$instrument <- as.factor(tbl_tidy_obs$instrument)
tbl_tidy_obs$jerkind <- as.factor(tbl_tidy_obs$jerkind)
tbl_tidy_obs$mean <- as.numeric(tbl_tidy_obs$mean)
tbl_tidy_obs$stddev <- as.numeric(tbl_tidy_obs$stddev)

rowlist <- list(subject = numeric(),
                 activity = character(),
                 domain = character(),
                 motioncomponent = character(),
                 instrument = character(),
                 jerkind = character(),
                 mean = numeric(),
                 stddev = numeric()
                 )
starttime <- now()
msg <- paste("Tidying data started at",
             paste(hour(starttime), minute(starttime), sep=":"),
             "Please be patient",
             sep = " ")
print(msg)
for (i in 1:nobs) {
        if (i%/%1000*1000 == i) {
                msg <- paste("completed",
                             as.character(i),
                             "of",
                             as.character(nobs),
                             "observations",
                             sep = " ")
                print(msg)
        }
        rowlist[1] <- tbl_messy_obs[i,1]
        rowlist[2] <- tbl_messy_obs[i,2]
        for (j in 3:nvar) {
                 rowlist[3] <- substr(varname[j],1, 1)
                 if (grepl("Body", varname[j])>0) {
                         rowlist$motioncomponent <- "Body"
                 } else { 
                         rowlist$motioncomponent <- "Gravity"
                 }
                 if (grepl("Acc", varname[j])>0) {
                         rowlist$instrument <- "Acc"
                 } else {
                         rowlist$instrument <- "Gyro"
                 }
                 if (grepl("Jerk", varname[j])>0) {
                         rowlist$jerkind <- "Jerk"
                 } else {
                         rowlist$jerkind <- NA
                 }
                 if (grepl("mean",varname[j])>0) {
                         rowlist$mean <- 
                                 as.numeric(tbl_messy_obs[i,j])
                         rowlist$stddev <- NA
                 }
                 if (grepl("std", varname[j])>0) {
                         rowlist$stddev <- 
                                 as.numeric(tbl_messy_obs[i,j])
                         rowlist$mean <- NA
                 }
                 rowindex <- (i-1)*(nvar-2) + (j-2)
                 tbl_tidy_obs[rowindex, ] <- rowlist
        }
}

endtime <- now()
msg <- paste("Tidying data completed at",
             paste(hour(endtime), minute(endtime), sep=":"),
             "Thanks for your patience",
             sep = " ")
print(msg)

setkey(tbl_tidy_obs,subject,activity,domain,motioncomponent,instrument, jerkind)

## save the tidy table to project directory

write.table(tbl_tidy_obs, "tidydata.txt",row.names = FALSE)

## Summarise the tidy data by subject, activity and feature combination, taking
## calculating the mean of the mean and standard deviation variables. Write this 
## summary table to the working directory.

tbl_summary <- tbl_tidy_obs %>%
         group_by(subject,
                  activity,
                  domain, 
                  motioncomponent, 
                  instrument,
                  jerkind 
                 ) %>%
         summarise_all(mean,na.rm=TRUE)

write.table(tbl_summary, "summarydata.txt", row.names = FALSE)
