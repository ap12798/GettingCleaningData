# Getting-and-Cleaning-Data
This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:
unzip file
test and training files for activity and combine and changing column title to activity
test and training files for activity and combine and changing column title to subject
test and training files for activity and combine
changed column name to activity and subject respectively
taking observations from Data_Feature_Labels and using those has column names for Data_Features
combining subject and activity
combining features and combine
subset on mean or standard dev
selectedNames<-c(as.character(Data_Features_mn_std), "subject", "activity" )
reading in activity labels and setting as factors
replacing names
will create the text file the "tidy" dataset
