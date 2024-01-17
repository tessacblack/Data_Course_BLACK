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

# Task 4: Find the csv files and save as object
csv_files <- list.files(path = "Data", pattern = ".csv", recursive = TRUE)



#### Task 5: How many files match using the length function? 
?length()
# Anything in your environment is an object 
length(csv_files)
# You can save legnth in your environment as an object
y <- length(csv_files)
# This saved the length as an integer basically, and you can use it as a number



#### Task 6: Open the wingspan_vs_mass.csv file and store the contents as an R object named “df” using the read.csv() function
# because this file isn't in the directory that this project is in, we have to either give R the directory or use the following (Using the following is easier bc you don't have to know the exact path to the file)
list.files(pattern = "wingspan_vs_mass.csv", recursive = TRUE)
# to get R to read it, you can copy and paste the above code into read.csv
df <- read.csv(list.files(pattern = "wingspan_vs_mass.csv", recursive = TRUE))

### Task 7: Inspect the first 5 lines of this data set using the head() function
?head()
head(df,n=5)
# this worked 


### Task 8: Find any files (recursively) in the Data/ directory that begin with the letter “b” (lowercase)
list.files(path = "Data", pattern = "^b",recursive = TRUE)
# the carat means "starts with" 
# this is case sensitive so make sure you do lower case b 
# regular expression coding can be useful because it lets you do complicated pattern matching 
# the * means ends with
list.files(path = "Data", pattern = "[^b, B]*.csv",recursive = TRUE)
# This means: starts with b or B, ends with .csv


### Task 9: Write a command that displays the first line of each of those “b” files (this is tricky… use a for-loop)
# first you need to tell R what those three files are. Save as a variable
bfiles <- list.files(path = "Data", pattern = "^b",recursive = TRUE)
readLines(bfiles[1])
# no such file or directory. We told R "starting from Data", so those file paths don't include Data
bfiles <- list.files(path = "Data", pattern = "^b",recursive = TRUE,full.names = TRUE)
readLines(bfiles[1],n=1)
# this read in just the first line of the first file 
readLines(bfiles[1],n=1)
# read lines works with files, but head works with objects. since we're working with the files right now, we need to use readlines

# for-loop
# for-loops are ways to loop through unknown/infinite numbers of things and do the same thing with each one of them 
# to write a for-loop in R, there is a for function
## for function wants a variable. Dr. Zhan usually calls it i for iteration
## this for-loop is going to run 3 times (bc we have 3 things in bfiles)
for(i in bfiles){
print(readLines(i, n=1))
}

# example for-loop
x <- c("Cool", "Boring", "Stupid")
for(i in x){
  print(paste0("Your mom is",i))
}
