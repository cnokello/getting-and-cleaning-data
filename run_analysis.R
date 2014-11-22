###
### author: cnokello
### created: 18-Nov-2014
### updated: 21-Nov-2014
### This script analyses the activity sensor data at 
### http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
### by following instructions presented at the Coursera's Getting and Cleaning Data course
### in the Data Science Specialization 
### All functionality needed to process the data is in this one script.
###

### 
### Import required packages
library(dplyr)
library(data.table)
library(reshape)

###
### A utility function that is used to read, format and transform both 'train' and 'test' data
### Its called once for each data type, i.e., once for 'train' data and once for 'test' data
###
getData <- function(featuresFileUrl, dataFileUrl, activityFileUrl, subjectFileUrl) {
  ## FEATURES
  ##
  ## Features or variables
  print('Formatting variables...')
  features <- read.csv(featuresFileUrl, header = F, sep = ' ')
  names(features) <- c('id', 'name')
  
  ## Mean and Standard Deviation variables
  mean_variables <- grep('mean', features$name, value = T, perl = T)
  std_variables <- grep('std', features$name, value = T, perl = T)
  mean_std_variables <- c(mean_variables, std_variables)
  print('Done.')
  
  
  ## DATA
  ##
  ## Load data
  print('Formatting data...')
  x_data <- read.table(dataFileUrl, header = F, strip.white = T)
  names(x_data) <- features$name
  
  ## Incorporate variable names
  names(x_data) <- features$name
  
  ## Extract only mean and standard deviation variables from x_train data
  x_data_mean_std <- x_data[, eval(quote(mean_std_variables))]
  print('Done.')
  
  ## ACTIVITY
  ##
  ## Incorporate the activity variable to x_train_data
  print('Incorporating activities...')
  y_data <- scan(activityFileUrl)
  x_data_mean_std$activity <- y_data
  print('Done.')
  
  ## SUBJECT
  ## 
  ## Incorporate the subject variable to the data
  print('Incorporating subject...')
  subject <- scan(subjectFileUrl)
  x_data_mean_std$subject <- subject
  print('DOne.')
  
  x_data_mean_std
}

### 
### Analysis is initated by calling this method with base directory of the data
### NOTE: The base directory MUST NOT include the traling slash ('/')
### NOTE: On Windows operating system, forward slashes ('/') MUST be used in file paths
### Example: 'C:/ws/r/data/sensor_data'
###
run <- function(wd = getwd()) {
  ### General file path setup
  activity_label_file_url = paste(wd, 'activity_labels.txt', sep = '/')
  features_file_url <- paste(wd, 'features.txt', sep = '/')
  
  ### Load X_train data
  data_file_url <- paste(wd, 'train/X_train.txt', sep = '/')
  activity_file_url <- paste(wd, 'train/y_train.txt', sep = '/')
  subject_file_url <- paste(wd, 'train/subject_train.txt', sep = '/')
  x_train_mean_std <- getData(features_file_url, data_file_url, activity_file_url, subject_file_url)
  
  ### Load x_test data
  data_file_url <- paste(wd, 'test/X_test.txt', sep = '/')
  activity_file_url <- paste(wd, 'test/y_test.txt', sep = '/')
  subject_file_url <- paste(wd, 'test/subject_test.txt', sep = '/')
  x_test_mean_std <- getData(features_file_url, data_file_url, activity_file_url, subject_file_url)
  
  ### Combine train and test data
  x_data <- rbind(x_train_mean_std, x_test_mean_std)
  
  ## Summarizing data; first group by subject and activity name, 
  ## then calculate mean for each variable
  print('Summaizing...')
  x_data_clean <- tbl_df(x_data)
  x_data_agg <- x_data_clean %>%
    group_by(subject, activity) %>%
      summarise_each(funs(mean)) %>%
        as.data.frame()
  
  print('Done.')
  
  # x_data_m <- melt(x_data, id.vars = c("subject", "activity"))
  # x_data_agg <- dcast(x_data_m, subject + activity ~ variable, fun = mean)
  
  # Incorporate activity labels
  print('Incorporating activity labels...')
  activity_labels <- read.csv(activity_label_file_url, header = F, sep = ' ')
  names(activity_labels) <- c('activityNumber', 'activityName')
  x_data_l <- merge(x_data_agg, activity_labels, by.x = 'activity', by.y = 'activityNumber', all = T)
  
  
  x_data_l$activity <- NULL
  x_data_l <- x_data_l[, c(1, ncol(x_data_l), 2:(ncol(x_data_l) - 1))]
  x_data_l <- rename(x_data_l, c('activityName' = 'activity'))
  print('Done.')
  
  # Modify variable names
  print('Modifying variable names...')
  varName <- function(originalName) {
    newName <- gsub("[\\(\\)]", "", originalName)
    newName <- toupper(gsub("-", "_", newName))
  }
  
  varNames <- lapply(names(x_data_l), varName)
  names(x_data_l) <- varNames
  print('Done.')
  
  print(paste('Writing out the tidy summary file to ', paste(wd, 'tidy_summary_data.txt', sep = '/')))
  x_data_f <- tbl_df(x_data_l) %>%
    arrange(SUBJECT, ACTIVITY) %>%
        write.table(file = paste(wd, 'tidy_summary_data.txt', sep = '/'), quote = T, sep = ',', row.names = F)

  names(x_data_l)
  # print('Done.')
}