##### WEEK 2 NOTES ####
# Tuesday, 16 Jan and Thursday, 18 Jan #

#### Tuesday, January 16 ####
# Main focus: 

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

#### Thursday, January 18 ####
# Main focus: Working with vectors

# Package spotlight ####
# QR code package lets you make a qr code out of any vector that has a length of 1
# so you can make the url you want into a vector and then turn it into a qr code
url <-  exampke
qr <- qrcode::qr_code(url)
plot (url)

# Installing packacges ####
install.packages("qrcode") #this installs it 
library(qrcode) #library loads the package


# Class notes ####

x <- c(1,2,3,4,5)
for (i in x){
  print(i + 1)
}

# R was designed so that for-loops aren't super necessary because R is a vectorized language
x + 1
x^3

# Vectors have magnitude and one direction, which means it has one dimension
# The c function makes a vector

# 1:5 is the shortcut for all of the numbers between 1 and 5. This is a common way to make a vector
# We made a numeric vector. Numeric is the class 
1:5
seq(1,100,by=5)

class(x)
length(x) #the length of x is itself a vector of length 1
length(length(x)) # see 

class(class(x)) #the class of x is the word numeric. so the class of "numeric" is character. If you see something in quotes, it will always be a character class

#Everything in a vector has to be in the same class. A vector can't have numbers and characters 
c(1,"a") #this will turn 1 into a character when you run it 

c(1:10, "a")

# vector 
# has a class (numeric, character)
# has one dimension
# everything in a vector must all be same class 
# length can = 0
length(c()) #see. This asks for the length of an empty vector, which is 0

#Making some vectors
# Letters is a vector, so it has one dimension
a <- 1:10
b <- 2:11
c <- letters [1:10]
head(letters,n=10)

# What if you want the first, third, and fifth letters 
c <- letters[c(1,3,5)] # letters is one dimensional. we have to tell it that we only want 1, 3, and 5 from letters 
# This makes 1, 3, and 5 its own numeric vector 

a
b
c
# a and b are integer class, but you can treat this as a numeric class

# how do we stick a b and c together and have all of them retain their class
c(a,b,c) #this turned them all into characters so that's not going to work 
cbind(a,b,c) #i don't think this worked either

# New class of objects: Data Frames 
z <- data.frame(a,b,c) #In our environment, this isn't a value anymore. It's a data frame, which is the basic unit of most data sets 
# You can't usually make a data frame this way. You can only do it this way if all of your variables (eg a, b, c) are the same length

# What is the class of z? The length? The dimension?
class(z) #"data.frame"
length(z) #3
dim(z) #10 3

# The length R spits out is the number of columns. R is saying that z has 3 things in it. Which is true, because each of those three things is a vector. If you click on z, you'll see that all of those vectors retained their respective classse
# rep function repeats something 
d <- rep(TRUE, 10)
z <- data.frame(a,b,c,d) #adding something new to the data frame, overwriting our original z
class (d) #"logical"

# logical class vectors
1>0
0>=0
3<1
1==1 #'==' means 'equal to'
1!=1 #'1=' means 'not equal to'

5>a #is 5 greater than the entire 'a' vector


# What if you want to change your data frame so that you only have the rows where a<5
a[5>a] #this worked. why? First, it evaluates the statement inside of the square brackets. Then, it only gives you the things that evaluate to TRUE

# What if we want to apply this to the whole z dataframe? Data frames are two dimensional, while vectors are onen dimensional. Data frames want 2 dimensions inside of the square brackets. 
# Data frames have 2 dimensions [row, column]
z[1,3] # In data frame z, give me row 1 column 3 
z[1,] # Gives you the first row from every column 
z[5 > a,]
# These functions allow us to make subsets of fulll data sets using true/false questions

# What if we want to pull all rows where column c is equal to the letter b?

## Pull out rows of z where column c is equal to "b"
z[c == "b",]

# We all have a built in data set called Iris
iris

# Pull all rows of iris where the sepal length is >5
iris[Sepal.Length > 5,] #error: object 'Sepal.Length' not found
# We don't have anything called Sepal Length in our environment. However, we know it lives in iris. 
# If you type in iris$, it will show you the columns in a data set 


iris[iris$Sepal.Length>5,] #this will return all of the rows
iris$Sepal.Length>5 #this will return the true/false for our question 

#how many of the irises have a sepal length >5?
dim(iris[iris$Sepal.Length>5,]) #this gives us two numbers 
nrow(iris[iris$Sepal.Length>5,]) # will just give us number of rows

big_iris <- iris[iris$Sepal.Length>5,]

# want to add a new column to big_iris called "area" that is equal to sepal.length * sepal.width
# remember that we can do vectorized calcluations very quickly 
iris$Sepal.Length * iris$Sepal.Width #gives us sepal area calculation that we want to perform 

big_iris$Sepal.Area <- big_iris$Sepal.Length * big_iris$Sepal.Width

# show just "setosa" from big_iris
big_setosa <- big_iris[big_iris$Species == "setosa",] #Go into big iris, specifically the column species, and pull the rows where species = setosa. then create a new dataframe called big_setosa

# calculate mean sepal area from big_setosa
mean(big_setosa$Sepal.Area) #in Big_setosa, calculate the mean of the vector 'Sepal_Area'
plot(big_setosa$Sepal.Length,big_setosa$Sepal.Width)
sd(big_setosa$Sepal.Area) #standard dev
sum(big_setosa$Sepal.Area)
min(big_setosa$Sepal.Area)
max(big_setosa$Sepal.Area)
summary(big_setosa$Sepal.Area)
cumsum(big_setosa$Sepal.Area) #cumulative sum
cumprod(big_setosa$Sepal.Area) #cumulative product

# True/False questions will allow you to color your data set


# Assignment: spend several hours playing around with vectors, do math with them, put them in data frames, and make subsets of data with them ####
## Figure out how to say in one statement: give me the rows in iris where species is setosa and sepal area is greater than 5 ####
## Figure out how to say in one statement: give me the rows in iris where species is setosa or virginica ####
## How to ask and/or questions and true/false questions. Just get comfortable with subsetting. Make sure you understand how square brackets work ####

## Assignment: Figure out how to say in one statement: give me the rows in iris where species is setosa and sepal area is greater than 5 ####
iris[iris$Species=="setosa" & iris$Sepal.Length * iris$Sepal.Width>5,]

## Assignment: Setosa or virginica ####
iris[iris$Species==c("setosa","virginica"),]