rm(list = ls(all = TRUE))
library(plyr) # load plyr first, then dplyr 
library(data.table) # a prockage that handles dataframe better
library(dplyr) # for fancy data table manipulations and organizatio


temp <- tempfile() # initialize a vector to store file
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
unzip(temp) #provides the list of files 


# Directories and files
data_dir <- "UCI\ HAR\ Dataset"
feature_file <- paste(data_dir, "/features.txt", sep = "")
activity_labels_file <- paste(data_dir, "/activity_labels.txt", sep = "")
x_train_file <- paste(data_dir, "/train/X_train.txt", sep = "")
y_train_file <- paste(data_dir, "/train/y_train.txt", sep = "")
subj_train_file <- paste(data_dir, "/train/subject_train.txt", sep = "")
x_test_file  <- paste(data_dir, "/test/X_test.txt", sep = "")
y_test_file  <- paste(data_dir, "/test/y_test.txt", sep = "")
subj_test_file <- paste(data_dir, "/test/subject_test.txt", sep = "")

# Read data from file
features <- read.table(feature_file, colClasses = c("character"))
activity_labels <- read.table(activity_labels_file, col.names = c("ActivityId", "Activity"))
x_train <- read.table(x_train_file)
y_train <- read.table(y_train_file)
subj_train <- read.table(subj_train_file)
x_test <- read.table(x_test_file)
y_test <- read.table(y_test_file)
subj_test <- read.table(subj_test_file)

############################################################################
# 1. Merges the training and the test sets to create one data set
###########################################################################

# Merge sensor data
train_sensor_data <- cbind(cbind(x_train, subj_train), y_train)
test_sensor_data <- cbind(cbind(x_test, subj_test), y_test)
sensor_data <- rbind(train_sensor_data, test_sensor_data)

# Label columns
sensor_labels <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]
names(sensor_data) <- sensor_labels

###################################################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
####################################################################################################

sensor_mean_std <- sensor_data[,grepl("mean|std|Subject|ActivityId", names(sensor_data))]

#####################################################################################################
# 3. Uses descriptive activity names to name the activities in the data set
######################################################################################################

sensor_mean_std <- join(sensor_mean_std, activity_labels, by = "ActivityId", match = "first")
sensor_mean_std <- sensor_mean_std[,-1]

#######################################################################################################
# 4. Appropriately labels the data set with descriptive names.
#######################################################################################################

# Remove parentheses
names(sensor_mean_std) <- gsub('\\(|\\)',"",names(sensor_mean_std), perl = TRUE)
#Make syntactically valid names from vector
names(sensor_mean_std) <- make.names(names(sensor_mean_std))
# Assign proper names
names(sensor_mean_std) <- gsub('^t',"Time",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('^f',"Frequency",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('Acc',"Acceleration",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('GyroJerk',"AngularAcceleration",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('Gyro',"AngularSpeed",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('Mag',"Magnitude",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('\\.mean',".Mean",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('\\.std',".StandardDeviation",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('Freq\\.',"Frequency.",names(sensor_mean_std))
names(sensor_mean_std) <- gsub('Freq$',"Frequency",names(sensor_mean_std))

###############################################################################################################################
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
###############################################################################################################################

tidy = ddply(sensor_mean_std, c("Subject","Activity"), numcolwise(mean))
write.table(tidy, file = "sensor_averages_data.txt")
