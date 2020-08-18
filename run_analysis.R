library(readr)
library(dplyr)

activity<-read.table("activity_labels.txt", col.names = c("n","functions"))
features<-read.table("features.txt", col.names = c("code","functions"))
#TEST data##############################
x_test<-read.table("test/x_test.txt", col.names = features$functions) 
y_test<-read.table("test/y_test.txt", col.names = "code")
subject_test<-read.table("test/subject_test.txt", col.names = "subject")

#TRAIN data#############################
x_train<-read.table("train/x_train.txt", col.names = features$functions) #features
y_train<-read.table("train/y_train.txt", col.names = "code") #activity label
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
# MERGE DATASET ##########
x <- rbind(x_train,x_test)
y <- rbind(y_train,y_test)
subject <- rbind(subject_train, subject_test)
merged <- cbind(subject,y,x)
#mean & sd ###################
TidyData <- merged %>% select(subject, code, contains("mean"), contains("sd"))
#descriptive activity names to name the activities in the data set
TidyData$code <- activity[TidyData$code,2]
#tidy labels the data set with descriptive variable names.
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))
# second, independent tidy data set with the average of each variable for each activity and each subject.
TidyDataset <- TidyData %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(TidyDataset, "TidyDataset.txt", row.name=FALSE)
