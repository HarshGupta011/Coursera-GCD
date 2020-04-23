## Reading all the files to the memory
features <- read.table("./files/features.txt",col.names = c("Num","Feature"))
activity<- read.table("./files/activity_labels.txt",col.names = c("code","Activity"))
X_test <- read.table("./files/test/X_test.txt",col.names = features$Feature)
X_train <- read.table("files/train/X_train.txt",col.names = features$Feature)
Y_test <- read.table("files/test/y_test.txt",col.names = "Label")
Y_train <- read.table("files/train/y_train.txt",col.names = "Label")
subject_test <- read.table("files/test/subject_test.txt",col.names = "Subject")
subject_train<- read.table("files/train/subject_train.txt", col.names = "Subject")

##Merging test and train values
X <- rbind(X_train,X_test)
Y <- rbind(Y_train,Y_test)
subject <-rbind(subject_train,subject_test)

##Extracting only mean and standard deviation measurements
colname<- grep("mean|std" , features$Feature )
X<-select(X,colname)

##Merging everything into 1 dataset
tidydata<- cbind(subject,Y,X)

##Use descriptive activity names to describe each activity ie use activity to rename the contents of label column
tidydata$Label <- activity[tidydata$Label, 2]

##Appropriately label the data set with descriptive variable names.
##I have already given names to the variables while reading from file
#Modifying the names to make it clearer

names(tidydata)[2] = "activity"
names(tidydata)<-gsub("Acc", "Accelerometer", names(tidydata))
names(tidydata)<-gsub("Gyro", "Gyroscope", names(tidydata))
names(tidydata)<-gsub("Mag", "Magnitude", names(tidydata))
names(tidydata)<-gsub("-mean()", "Mean", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-std()", "STD", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-freq()", "Frequency", names(tidydata), ignore.case = TRUE)

##creates a second, independent tidy data set with the average of each variable for each activity and each subject
AverageData<-summarise_all(group_by(tidydata,Subject,activity),mean)
write.table(AverageData, "./files/AverageData.txt", row.name=FALSE)
