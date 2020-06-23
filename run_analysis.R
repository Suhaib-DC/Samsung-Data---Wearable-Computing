
#reading the training data
Strain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")

#reading the test data
Stest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")

# merge data sets
Dtrain <- cbind(Strain, Ytrain, Xtrain)
Dtest <- cbind(Stest, Ytest, Xtest)
alldata <- rbind(Dtrain, Dtest)

# extract only the mean and std measurements 
feat <- read.table("./UCI HAR Dataset/features.txt")
meanloc <- grep("mean",feat$V2)
stdloc <- grep("std",feat$V2)
msdata <- alldata[,c(1,2,(meanloc+2),(stdloc+2))]

# fix labels
meannames <- grep("mean",feat$V2, value = T)
stdnames <- grep("std",feat$V2, value = T)
names(msdata) <- c("subject","label", meannames, stdnames)

#add descriptive activity names
act <- read.table("./UCI HAR Dataset/activity_labels.txt")

for(i in 1:length(msdata$label)){
        msdata$label[i] <- act[msdata$label[i],2]
}

#the average of each variable for each activity and each subject
s <- split(msdata, msdata$subject)
data <- data.frame()
label <- character()
subject <- integer()
for(i in 1:length(s)){
        for (j in 1:length(act$V2)){
                s1 <- s[[i]][s[[i]]$label == act[j,2],]
                m <- colMeans(s1[,3:length(s1)])
                data <- rbind(data,m)
                label <- c(label, act[j,2])
                subject <- c(subject, i)
        }
}

tidydata <- cbind(subject, label, data)
names(tidydata) <- c("subject","label", meannames, stdnames)
write.table(tidydata, file = "tidydata.txt", row.names = F)




