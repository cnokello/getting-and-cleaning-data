**Instructions** 

1. Change to the directory containing the script 'run_analysis.R'

2. Start R console if not using RStudio. Set working directory
   to the directory containing the 'run_analysis.R' script using the command
   > setwd('/path/to/script/folder')

3. If not yet installed, install the dplyr, data.table and reshape packages by running:
	> install.packages('dplyr')
	
	> install.packages('data.table')
	
	> install.packages('reshape')
	
4. To import the 'run_analysis.R' script in to your workspace, run:
	
	> source('run_analysis.R') 
	
	from within R console.
	This will import the above packages - dplyr, data.table and reshape - in addition to 
	making the functions within the script accessible
	
5. Run the analysis by running the following command from R console:
	> run('/path/to/assignment/data/root/folder')
	
	Replace '/path/to/assignment/data/root/folder' with the actual path to the root directory that
	contains the assignment data. I've assumed that you have NOT tampered with the structure 
	of this directory.
	