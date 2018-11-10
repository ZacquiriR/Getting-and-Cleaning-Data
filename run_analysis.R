#Required package
install.packages("reshape2")
library(reshape2)

#Retrieving the file and downloading
if(!file.exists(".data")){dir.create("./data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "./data/Samsung.zip")

#Unzip the file
unzip(zipfile = ".data/Samsung.zip", exdir = "./data")

#Extract activity labels & features
actlabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

#Read in the Data
#Test
subtest <- read.table("UCI HAR Dataset/test/subject_test.txt")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")

#Train
subtrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")

#Set column names
colnames(xtrain) <- features[,2]
colnames(xtest) <- features[,2]

colnames(ytest) <- "actID"
colnames(ytrain) <- "actID"

colnames(subtest) <- "subID"
colnames(subtrain) <- "subID"

colnames(actlabels) <- c("actID", "actName")

#Merge the Data
datatest <- cbind(ytest, subtest, xtest)
datatrain <- cbind(ytrain, subtrain, xtrain)
allinone <- rbind(datatrain, datatest)

#Keep only desired columns
cnames <- colnames(allinone)
wanted_columns <- (grepl("actID", cnames) | grepl("subID", cnames) | 
                        grepl("mean..",cnames) | grepl("std..",cnames))
meanstd_subset <- allinone[, wanted_columns == TRUE]

#Label the actvities
final_data <- merge(meanstd_subset, actlabels, by = "actID", all.x = TRUE)

#New Data set that sorts into levels then takes means
Tidyset <- aggregate(. ~subID + actID, final_data, mean)
Tidyset <- Tidyset[order(Tidyset$subID, Tidyset$actID),]

#Write Table
write.table(Tidyset, "tidy.txt", row.names = FALSE)