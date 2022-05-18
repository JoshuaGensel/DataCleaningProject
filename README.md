The run_analysis.R script performs all the analysis done in this project.

The directory structure is automatically setup. Then the data sets will be 
downloaded from the provided link and unzipped automatically.
The script will perform the modifications on the original files needed to
read them in prior to doing so.
The training and test data sets will be merged and afterwards only the mean()
and std() measurements will be selected.
To summarize the data all measurements were averaged for each activity and each subject.

Refer to the Codebook.md for a description on each of the variables.