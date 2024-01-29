#### Shit to know in R #### 

# Clear console shortcut ####
# ctrl + L 

# Inspecting a dataset ####
# I'm going to use the iris data for all of the examples 
nrow(iris) # Outputs number of rows
ncol(iris) # Outputs number of columns
dim(iris) # Output number of rows and columns 
head(iris) # Prints the first 6 lines of a dataframe
tail(iris) # prints the last 6 lines of a dataframe
str(iris) # Gives compact summary of dataframe, including # of rows and columns, 
# column names, variable type per column, and the first few objects in each column 
names(iris) # Gives just the names of columns 


# Navigating file paths in R ####
getwd() # Prints the path to your current working directory from the root of your computer
list.files() # Lists the files in your current directory. This cmd can be modified
list.files()[1:10] # Only the first ten files
list.files(pattern="x") # just filenames that have "x" in them
# The modifier recursive = TRUE tells R to look into folders that are within the 
# desktop folder
list.files(path="/Users/tessablack/Desktop",
           recursive=TRUE,
           pattern=".csv")[1:4]

# Importing data ####
read.csv("Data/wide_income_rent.csv") # This will just read the file into R, but it doesn't save it into the environment
wide_income_rent <- read.csv("Data/wide_income_rent.csv") # This will save it as a dataset in the environment

## Importing many files at a time ####
# read.csv isn't useful if you want to read in dozens of files at a time. You 
#don't want to type the path for every single file 
# You can save the path to all of the files in a given location as a vector
x <- list.files(pattern = ".csv",recursive = TRUE)
# Using this vector, you can then tell it to read in specific files or all of the files 

x # typing "x" pulls the paths for every file into our console
x[158] # pulls the path for object 158 into our console
read.csv(x[158])# Pulls the data from the 158th character from x into our console. 
# You have to save it as a dataset to get it to stay in the environment
#Reminder: character 158 is just the file path to that specific csv file

# Installing packages ####
install.packages("tidyverse") # this installs it. You can also install it from the packages panel
library(tidyverse) # 'library' loads the package

# For-loop format ####
for(var in seq) {
  command
}

