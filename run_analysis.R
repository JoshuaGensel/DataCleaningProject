#get the data set
#-------------------------------------------------------------------------------

if(!file.exists("./data")){dir.create("./data")}
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "./data/dataset.zip")
unzip("./data/dataset.zip", exdir = "./data")
#-------------------------------------------------------------------------------

#read in and format the data sets
#and naming the activities
#-------------------------------------------------------------------------------

#loading informational files
library(tidyverse)
activities = read_delim("./data/UCI HAR Dataset/activity_labels.txt", col_names = FALSE)
features = read_delim("./data/UCI HAR Dataset/features.txt", col_names = FALSE)
testlabels = read.delim("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
trainlabels = read.delim("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
testsubjects = read.delim("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
trainsubjects = read.delim("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)


#formatting .txt file of the data sets
#for the test data set
testdatastring = readLines("./data/UCI HAR Dataset/test/X_test.txt")
testdatastring = gsub("\\s\\s", " ", testdatastring)
writeLines(testdatastring, "./data/test.txt")
#for the training data set
traindatastring = readLines("./data/UCI HAR Dataset/train/X_train.txt")
traindatastring = gsub("\\s\\s", " ", traindatastring)
writeLines(traindatastring, "./data/train.txt")

#reading in the data sets
#for the test data set
testdata = read_delim("./data/test.txt", col_names = c("activity", features$X2)) %>%
    mutate(activity = testlabels$V1) %>%
    mutate(activity = tolower(activities$X2[activity])) %>%
    mutate(subject = testsubjects$V1, .before = activity)
#for the training data set
traindata = read_delim("./data/train.txt", col_names = c("activity", features$X2)) %>%
    mutate(activity = trainlabels$V1) %>%
    mutate(activity = tolower(activities$X2[activity])) %>%
    mutate(subject = trainsubjects$V1, .before = activity)
#-------------------------------------------------------------------------------

#merging the data sets
#-------------------------------------------------------------------------------

completedata = rbind(traindata, testdata)
#-------------------------------------------------------------------------------

#selecting only mean() and std() measurements
#-------------------------------------------------------------------------------
finaldata = select(completedata, 
                   subject,
                   activity,
                   grep("mean()", names(completedata), fixed = TRUE),
                   grep("std()", names(completedata), fixed = TRUE))
#-------------------------------------------------------------------------------

#creating summary data frame
#-------------------------------------------------------------------------------
sumdata = finaldata %>%
    group_by(activity, subject) %>%
    summarise(across(everything(), list(mean)))
#-------------------------------------------------------------------------------

#outputting files
#-------------------------------------------------------------------------------
if(!file.exists("./output")){dir.create("./output")}
write.table(finaldata, "./output/tidydata.txt", row.names = FALSE)
write.table(sumdata, "./output/summarydata.txt", row.names = FALSE)
#-------------------------------------------------------------------------------
