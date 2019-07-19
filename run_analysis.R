library(plyr)
# check to see if file exists already
if(!file.exists("./GCproject")){dir.create("./GCproject")}
# call URL and download zipped folder along with creating new folder called GCproject (getting and cleaning)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./GCproject/Dataset.zip",method="auto")
# unzip file
unzip(zipfile="./GCproject/Dataset.zip",exdir="./GCproject")
directory <- file.path("./GCproject" , "UCI HAR Dataset")
files<-list.files(directory, recursive=TRUE)
#test and training files for activity and combine and changing column title to activity
data_activity_test  <- read.table(file.path(directory, "test" , "Y_test.txt" ),header = FALSE)
data_activity_train <- read.table(file.path(directory, "train", "Y_train.txt"),header = FALSE)
Data_Activity<- rbind(data_activity_test, data_activity_train)
names(Data_Activity)<- c("activity")

#test and training files for activity and combine and changing column title to subject
data_subject_test  <- read.table(file.path(directory, "test" , "subject_test.txt"),header = FALSE)
data_subject_train <- read.table(file.path(directory, "train", "subject_train.txt"),header = FALSE)
Data_Subject <- rbind(data_subject_test, data_subject_train)
names(Data_Subject)<-c("subject")

#test and training files for activity and combine
data_features_test  <- read.table(file.path(directory, "test" , "X_test.txt" ),header = FALSE)
data_features_train <- read.table(file.path(directory, "train", "X_train.txt"),header = FALSE)
Data_Features<- rbind(data_features_test, data_features_train)
#changed column name to activity and subject respectively
Data_Features_Labels <- read.table(file.path(directory, "features.txt"),head=FALSE)
#taking observations from Data_Feature_Labels and using those has column names for Data_Features
names(Data_Features)<- Data_Features_Labels$V2

#combining subject and activity
Data_Combine <- cbind(Data_Subject, Data_Activity)
#combining features and combine
df <- cbind(Data_Features, Data_Combine)
#subset on mean or standard dev
Data_Features_mn_std<-Data_Features_Labels$V2[grep("mean\\(\\)|std\\(\\)", Data_Features_Labels$V2)]
 
#selectedNames<-c(as.character(Data_Features_mn_std), "subject", "activity" )
df<-subset(df,select=c(as.character(Data_Features_mn_std), "subject", "activity"))

#reading in activity labels and setting as factors
Activity_Labels <- read.table(file.path(directory, "activity_labels.txt"),header = FALSE)
df$activity<-factor(df$activity)
df$activity<- factor(df$activity,labels=as.character(Activity_Labels$V2))

#replacing names
names(df)<-gsub("Acc", "Accelerometer", names(df))
names(df)<-gsub("^t", "Time", names(df))
names(df)<-gsub("Mag", "Magnitude", names(df))
names(df)<-gsub("Gyro", "Gyroscope", names(df))
names(df)<-gsub("^f", "Frequency", names(df))
names(df)<-gsub("BodyBody", "Body", names(df))

#will create the text file the "tidy" dataset
df2<-aggregate(. ~subject + activity, df, mean)
df2<-df2[order(df2$subject,df2$activity),]
write.table(df2, file = "tidydata.txt",row.name=FALSE)
