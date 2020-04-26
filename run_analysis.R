#submission script
# started 25042020 10:34 - worked 2 hours
#started 26042020 8:00 worked one more hour

# mmm
# http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/
# not accessible. Pity.
# second one is OK
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#download ZIP file Ok

#Review criteria

#The submitted data set is tidy. <- examine
#The Github repo contains the required scripts. <- only one?
#GitHub contains a code book that modifies and updates the available codebooks with
#the data to indicate all the variables and summaries calculated, along with units, 
#and any other relevant information.  <- pick from descriptive text files in the root?
#The README that explains the analysis files is clear and understandable. 
# <- is this a description how the are cleansed and analysed
#The work submitted for this project is the work of the student who submitted it. <- no problem

# Start the clock!
timer <- proc.time()

# my way of path handling
pathPrefix <- "UCI HAR Dataset"
pathPrefixTest <- paste0( pathPrefix, "/test" )
pathPrefixTrain <- paste0( pathPrefix, "/train" )

# what packages do I need
library( dplyr )

#ToDO
#1Merges the training and the test sets to create one data set.
#2Extracts only the measurements on the mean and standard deviation for each measurement.
#3Uses descriptive activity names to name the activities in the data set
#4Appropriately labels the data set with descriptive variable names.
#5From the data set in step 4, creates a second, independent tidy data set with the average
#of each variable for each activity and each subject.

#in the end I did the labeling before the grep activities to understand the dataset

#visual analysis of the input files
#features.txt 561 lines --> column labels for X-test and X-train?

#test folder
#waht to do with the Inertial Signals files? these are all readable
#reading the discussions of this assignments are not quite clear, but my guess is that
#these are the base files that resulted in a few of the other files.
#subject_test.txt is a chinese character file? What/How? !!Not necessary!
#X-test.txt is normal readable; 561 columns - match
#Y-test.txt is also non normal?!!Not necessary!

#train folder
#same pattern for the files as in test folder
#train files are bigger than the test files

# understanding/Dimensions
# 30 volunteers
# 6 activities
# 561 features (combination of activities,. X,Y,Z and mathematic functions)
# 30% of data inside test, 70% in train <-- not relevant

# for each record:
#- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
# body_acc_x_xxx.txt, body_acc_y_xxx.txt, body_acc_z_xxx.txt
# !!Not necessary!
# total_acc_x_xxx.txt, total_acc_y_xxx.txt, total_acc_z_xxx.txt
#!!Not necessary!
#- Triaxial Angular velocity from the gyroscope. 
# body_gyro_x_xxx.txt, body_gyro_y_xxx.txt, body_gyro_z_xxx.txt
#!!Not necessary!
#- A 561-feature vector with time and frequency domain variables.                     <- X-test.txt
#- Its activity label.                                               <- Y-test.txt
#- An identifier of the subject who carried out the experiment.      <- subject_xxx.txt UNREADABLE with notepad

#What do I really need for this submission thing?

# 1. Merging the training and the test sets to create one data set:
#x and y files are meant as the row and column header

# Reading trainings tables:
x_train <- read.table(paste0( pathPrefixTrain, "/X_train.txt") )
y_train <- read.table(paste0( pathPrefixTrain, "/y_train.txt") )
subject_train <- read.table(paste0( pathPrefixTrain, "/subject_train.txt") )

# Reading testing tables:
x_test <- read.table(paste0( pathPrefixTest, "/X_test.txt") )
y_test <- read.table(paste0( pathPrefixTest, "/y_test.txt") )
subject_test <- read.table(paste0( pathPrefixTest, "/subject_test.txt") )

# Reading feature vector:
features <- read.table(paste0( pathPrefix, "/features.txt") )

# Reading activity labels:
activityLabels = read.table(paste0( pathPrefix, "/activity_labels.txt") )

# 4. Assigning column names: do it here to be able to understand the dataset
colnames(x_train) <- features[,2] #second column from features
colnames(y_train) <-"activityId"  #and these are Activity types
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

# Now merge the  data in one set:
#first tie the columns in the right order
#and bind the rows
mergedData <- rbind(
  cbind(y_train, subject_train, x_train), 
  cbind(y_test, subject_test, x_test))

# 2. Extracting only the measurements on the mean and standard deviation for each measurement
# search the column name list for mean/std/dev and keep the ID's
colNames <- colnames(mergedData)

# Create vector for defining ID, mean and standard deviation
# features examined: mean and std are the columns
filterVector <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

# Subsetting from setAllInOne:
outputData <- mergedData[ , filterVector == TRUE]


# From the data set in step 4, creates a second, independent tidy data set with the average
#of each variable for each activity and each subject.

outputData <- aggregate(. ~subjectId + activityId, outputData, mean)
outputData <- outputData[order(outputData$subjectId, outputData$activityId),]

# Add activity names tp the end of the dataset
outputData <- merge(outputData, activityLabels,
                    by='activityId',
                    all.y=TRUE)   #force output if no join
#and now reorder the columns
outputData <- 
  select( outputData, activityId, activityType, subjectId, everything())

# and write it to the  txt file without row numbers
write.table(outputData, file = "tidy_data_summary.txt", row.names = FALSE, append = FALSE)

# Stop the clock and let us know how long it took
print( proc.time() - timer )
