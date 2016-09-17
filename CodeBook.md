# GettingandCleaningDataProject
Getting and Cleaning Data Course Project
 
The script run_analysis.R performs the following steps as described in the course project's definition.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The script first merges all the similar data sets using the rbind() function having the same number of columns and referring to the same measures. The columns with the mean and standard deviation measures are taken from the main dataset. After extracting these columns, they are given appropriate names taken from features.txt.As activity data is addressed with values 1:6, we take the activity names and IDs from activity_labels.txt and they are substituted in the dataset.
On the whole dataset, those columns with vague column names are corrected.
Finally, we generate a new dataset with all the average measures for each subject and activity type. The output file is called sensor_averages_data.txt, and uploaded to this repository.

Variables
x_train, y_train, x_test, y_test, subj_train and subj_test contain the data from the downloaded files.
train_sensor_data, test_sensor_data and sensor_data merge the previous datasets to further analysis.
sensor_labels contains the correct names for the sensor_data dataset, which are applied to the column names stored in mean_and_std_features, a numeric vector used to extract the desired data.
A similar approach is taken with activity names through the activities variable.
all_data merges x_data, y_data and subject_data in a big dataset.
Finally, tidy contains the relevant averages which are then stored in a .txt file. ddply() is used to apply mean.