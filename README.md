**Instructions** 

1. In R console, use the command below to set the working directory to the base directory of the assignment data
   > setwd('/path/to/assignment/data/base/directory')
   
   Replace '/path/to/assignment/data/base/directory' with the actual path to the base directory of the assignment data.
   All file paths MUST use forward slashes ('/') even on Windows OS. For example:
   
   > 'C:/ws/r/data/sensor_data' is correct
   
   > 'C:\ws\r\data\sensor_data' is incorrect

3. If not yet installed, install dplyr, data.table and reshape packages by running:
	> install.packages('dplyr')
	
	> install.packages('data.table')
	
	> install.packages('reshape')
	
4. To import the 'run_analysis.R' script in to your workspace, run:
	
	> source('/path/to/run_analysis.R') 
	
	from within R console. '/path/to/run_analysis.R' is the file path to 'run_analysis.R' script. 
	This will import the above packages - dplyr, data.table and reshape - in addition to 
	making the functions within the R script accessible
	
5. Run the analysis by running the following command from R console:
	> run()
	
	If your working directory is not the base directory of the assignment data, then run:
	
	> run('/path/to/assignment/data/root/directory')
	
	instead.
	
	Replace '/path/to/assignment/data/root/directory' with the actual path to the root directory that
	contains the assignment data. I've assumed that you have NOT tampered with the structure 
	of this directory.
	
	Also, note that all paths MUST use forward slashes even on Windows operating systems. Example:
	
	> C:/ws/r/data/sensor_data is correct
	
	> C:\ws\r\data\sensor_data is incorrect
	
	
**How it works**

The 'run_analysis.R' script has two functions:

**run(wd = getwd())**:

This has one optional parameter, wd, which points to the base directory of the assignment data. 
The function begins the analysis by setting:  
* Path to training data 
* Path to test data 
* Path to features data 
* Path to activity labels data.

It calls another function, getData, that loads both the training and test data sets. It then combines the training and test data sets into a single data set.
Then, by using chaining and dplyr's group_by and summarise_each functions, it groups the data set by subject and activity and applies the mean function column-wise. It then incorporates activity labels into the data set. Finally, by using a combination of lapply and regular expression functions, it renames the variable names.
This function is called once during the analysis.

**getData(featuresFileUrl, dataFileUrl, activityFileUrl, subjectFileUrl)**: 

This function is used to load both training and test data sets, extract mean and standard deviation related variables and incorporate activity and subject variables.

It's called twice; once for training data set and once for test data set.