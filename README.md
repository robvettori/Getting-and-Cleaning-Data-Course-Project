# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Downloads and unzips the UCI HAR dataset into the working directory.
2. Loads the activity and feature information.
3. Loads the training and test datasets, keeping only the columns with mean or standard deviation measurements.
4. Loads and merges by column the activity and subject data for each dataset.
5. Creates a tidy dataset `tidy.txt` that consists of the mean value of each variable for each subject and activity pair.
