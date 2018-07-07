# Load and process X_test & y_test data.
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt") 

# get the column names
features <- read.table("./UCI HAR Dataset/features.txt")
features <- features[,2]
# Rename xtest columns
names(Xtest) = features
# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)
Xtest = Xtest[,extract_features]

# Activities labels
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activitylabels <- activitylabels[,2]

# get activity labels
ytest[,2] = activitylabels[ytest[,1]]
names(ytest) = c("Activity_ID", "Activity_Label")
names(subjectTest) = "subject"

# merge test data
testData <- cbind(subjectTest, ytest, Xtest)

# Load Xtrain & ytrain data.
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")

subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Rename xtrain columns

names(Xtrain) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
Xtrain = Xtrain[,extract_features]

# get activity data
ytrain[,2] = activitylabels[ytrain[,1]]
names(ytrain) = c("Activity_ID", "Activity_Label")
names(subjectTrain) = "subject"

# merge traing  data
trainData <- cbind(subjectTrain, ytrain, Xtrain)

# Merge test and train data
data = rbind(testData, trainData)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melted      = melt(data, id = id_labels, measure.vars = data_labels)

# get the mean if dataset using dcast function and applying the mean function
tidyData   = dcast(melted, subject + Activity_Label ~ variable, mean)

write.table(tidyData, file = "tidy_data.txt", row.name=FALSE)
