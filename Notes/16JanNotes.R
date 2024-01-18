getwd()
list.files()
getwd()
list.files()[1:10]
list.files(pattern="x")

list.files(pattern = ".csv", recursive = TRUE)

"Data/wide_income_rent.csv"
readLines("Data/wide_income_rent.csv")
# Read lines will read text from a "connection", where a connection is just the path to the file. So you can paste the file path inside the () on read lines and it will read that file 
# All that read lines can do is open a file and look for line breaks in a file (eg, where you press enter on an excel file)
# This isn't the most useful. The data is not in the environment which means that R doesn't know anything about what's in this file 
# We can save it into the environment 

read.csv("Data/wide_income_rent.csv")
# This was actually helpful
# What if you need to read in all 161 files? You don't want to type them all in. You can automate it.
# In line 7 it's showing us the path to all of the .csv files 
# adding a variable name and the little <-symbol will save them 

x <- list.files(pattern = ".csv",recursive = TRUE)
# Now we can see that x is in the environment 
x
# Typing x and then running that command pulls all of those file paths into our console 

x[158]
# This just pulled object #158 into our console
# The technical term for this is 'the 158th character number of the vector x'

read.csv(x[158])
# this pulled just the data from the 158th character from x into our console. Reminder: character 158 is just the file path to that specific csv file
# How do we save this data? Save it under a variable name 

dat <- read.csv(x[158])
# Now we have the data set from 158 in our environment. Since we told it that it's a .csv, it is pulled into the environment as an actual data set
# Columns are variables

csv_files <- list.files(path = "Data", pattern = ".csv", recursive = TRUE)