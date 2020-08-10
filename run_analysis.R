library(readr)
library(dplyr)
activity<-read.table("activity_labels.txt")
features<-read.table("features.txt")
#TEST data##############################
x_test<-read.table("test/x_test.txt", col.names = features$V2) 
x_test$activity <- y_test$V1
y_test<-read.table("test/y_test.txt")
subject_test<-read.table("test/subject_test.txt")
x_test$subject <- factor(subject_test$V1)

#TRAIN data#############################
x_train<-read.table("train/x_train.txt", col.names = features$V2) #features
y_train<-read.table("train/y_train.txt") #activity label
x_train$activity <- y_train$V1
subject_train<-read.table("train/subject_train.txt")
x_train$subject <- factor(subject_train$V1)

# MERGE DATASET ##########
df <- rbind(x_test,x_train)

#mean & sd ###################
df_mean<-colMeans(df)
df_mean
ncol(df)
df_sd <- df %>% summarise_if(is.numeric, sd)
df_sd

#add descriptive values for activity label
df$activitylabel <-factor(df$activity, labels= c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

#tidy data set with the average of each variable for each activity and each subject.

library(reshape2)
table(df$activity)
features.colnames = grep("std\\(\\)|mean\\(\\)", colnames(df), value=TRUE)
df.melt <-melt(df, id = c('activitylabel', 'subject'), measure.vars = features.colnames)
df.tidy <- dcast(df.melt, activitylabel + subject ~ variable, mean)

write.table(df.tidy, file = "tidydataset.txt", row.names = FALSE)
