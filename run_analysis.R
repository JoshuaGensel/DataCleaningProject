#get the dataset
#-------------------------------------------------------------------------------

if(!file.exists("./data")){dir.create("./data")}
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "./data/dataset.zip")
unzip("./data/dataset.zip", exdir = "./data")
#-------------------------------------------------------------------------------

#read in the data sets
#-------------------------------------------------------------------------------

#loading informational files
library(tidyverse)
activities = read_delim("./data/UCI HAR Dataset/activity_labels.txt", col_names = FALSE)
features = read_delim("./data/UCI HAR Dataset/features.txt", col_names = FALSE)
testlabels = read.delim("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
trainlabels = read.delim("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)

#formatting .txt file of the data sets
testdatastring = readLines("./data/UCI HAR Dataset/test/X_test.txt")
testdatastring = gsub("\\s\\s", " ", testdatastring)
writeLines(testdatastring, "./data/test.txt")

#reading in the data sets
library(data.table)
testdata = read_delim("./data/test.txt", col_names = c("activity", features$X2)) %>%
    mutate(activity = testlabels$V1) %>%
    mutate(activity = tolower(activities$X2[activity]))
