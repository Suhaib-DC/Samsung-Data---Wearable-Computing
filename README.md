---
title: "README"
author: "SuhaibDC"
date: "6/23/2020"
output: html_document
---



## Reading the data

This code is for reading the row data from UCI HAR Dataset directory, note that it should be in the working directory.

```{Reading code}

#reading the training data
Strain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")

#reading the test data
Stest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
```

## Merging the training and test datasets

I merge the training data together(subject, y, and x), I do the same with the test data, then I merge the two sets together, all using cbind and rbind commands.

```{merging code}
# merge data sets
Dtrain <- cbind(Strain, Ytrain, Xtrain)
Dtest <- cbind(Stest, Ytest, Xtest)
alldata <- rbind(Dtrain, Dtest)

```

## Extracting only mean and standerd daviation measurements

by using the features file, I searched for the features that contains the word mean or std in it using the grep command, and I assumed that those are the related features.

```{extracting code}
# extract only the mean and std measurements 
feat <- read.table("./UCI HAR Dataset/features.txt")
meanloc <- grep("mean",feat$V2)
stdloc <- grep("std",feat$V2)
msdata <- alldata[,c(1,2,(meanloc+2),(stdloc+2))]

```

## Fixing labels and activity names

I think that the names in the provided files for features and activities is most descriptive names, so I took the nanes from the files by grep command, I used the features.txt and activity_labels.txt files. with simble for loop i replaced the numbers in y by the corresponding activity label.

```{naming code}
# fix labels
meannames <- grep("mean",feat$V2, value = T)
stdnames <- grep("std",feat$V2, value = T)
names(msdata) <- c("subject","label", meannames, stdnames)

#add descriptive activity names
act <- read.table("./UCI HAR Dataset/activity_labels.txt")

for(i in 1:length(msdata$label)){
        msdata$label[i] <- act[msdata$label[i],2]
}

```

## Reshaping the data by averaging all the variables



```{averaging code}
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


```



