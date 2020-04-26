This codebook is part of the final assignment for Getting and Cleansing data on Coursera

About source data

A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
Here  the data for the project can be downloaded: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The description of the data can be found in the readme.txt file in there.

This documentation is far from complete  :(:).
I had to study the data files to understand what this is all about.
In the R-code file I kept my notes for this.

In the end 8 files were relevant for this assignment:
- x, y and subject text files in test folder (3 files) and in train folder (another 3 files)
- activity labels.txt 
- features.txt

About R logic

My R-logic does not follow the steps from the assignment exactly.
For my understanding it was handy to get the column names as first transformation before continuing with the nexts teps.

SO:
Step 1;  Read the training and the test sets and the other data
Step 2;  adding descriptive labels 
Step 3; merge the dataset
Step 4; filter the dataset for all mean and deviation relevant columns
Step 5; add the activity labels
Step 6; calculate means, sort the data and rearrange the columns
Step 7; write the file

About variables:

    x_train, y_train, x_test, y_test, subject_train and subject_test contain the data from the downloaded files.
    features contains the correct names for the x_data dataset, which are applied to the column names 
    outputData is the resulting dataset

Nothing to add at this moment