# 20 January: practicing with vectors and datasets 

### Video: Basic Math in R Programming by Simon Sez IT 
# multiplication is done with one asterisk, exponents are done with two asterisks
3*2
3**2

# Assigning variables
# make sure you name your variables correctly so that you and others can read it 
fifteen <- 7+8
# You can assign variables to many different data types, including character strings and words. Anything in quotations is a character
apple <- "apple"
# You can use your variables in functions and calculations

fifteen*2


# Video: Introduction to Vectors in R Programming by Simon Sez IT

# Vectors are a 1-dimensional data structure in R that are a group of similar objects. The objects inside of the vector are called components, and components must all be the same data type
# Some data types are more general than other data types (e.g., logical data types (true/false) are less general than a character data type)

#### vector creation ####

# 1. single value
#     Vectors with a single value in them are called character vectors 
hi <- "hi"
# You can ask questions about this vector
is.vector(hi) #TRUE

# 2. Colon to create a sequence 
vec1 <- 3:9 # creates a vector with the integers from 3 to 9
vec1
is.vector(vec1) #TRUE

# 3. Sequence operator
# similar to the colon, but you can specify how much you want it to count by. 
vec2 <- seq(1,9,by=2)
vec2
is.vector(vec2)

# 4. c() combine function
# combines all values you type into a single vector 
vec3 <- c(3, 4, 5, 10)
vec3
is.vector(vec3)

# what happens if...you try to combine integers and characters into a vector
vec4 <- c(3,"hi",4)
vec4
is.vector(vec4)
# vectors only allow the components to be a single data type. R will coerce the other variables to match the same variable type 

# what happens if you try to combine integers and logical values
vec5 <- c(0, TRUE, FALSE, 10)
vec5
is.vector(vec5)
# R has coerced TRUE and FALSE into integers 

# logical, character, integer, and numeric data types
vec6 <- c(TRUE, "hi", FALSE, 1, 4.533)
vec6
is.vector(vec6)
# R coerced everything into characters since they are the most general data type 


### Vector indexing ####

greetings <-c("hi","hello","hola","hey")
# single component indexing
greetings[1]
# the square brackets gives us only the first component in this vector
# R starts its indexing at 1 

# negative indexing removes the item at that index and returns everything else.
greetings[-1] # removes "hi" and returns the other three greetings
# this doesn't change the greetings variable unless you save it as greetings again 

# multiple component indexing
greetings[c(1,3)]
# you cannot mix positive and negative indices 
greetings[c(2,-1)]

# logical indexing
greetings[c(TRUE,FALSE,FALSE,TRUE)] #only returns the ones that are true 

# Numeric vectors
num_vec <- c(5,9,30,0,-8)

# logical indexing
num_vec<6 # tells you which components in num_vec are less than 6
num_vec[num_vec<6] # this will only return the components that are less than 6


#### Video: R tutorial 02: Vectors by Michael gastner's Quantitative reasoning ####
# the function c() combines the numbers or other values that we put between the parentheses
scores <- c(5,6,1,6,3)
scores

#elements in a vector are accessed using square brackets 
scores[3] # lets us view the third component in this vector

# you can perform operations on individual elements 
scores[3]+scores[5]

x <- c(2,6,3,2,3)
scores+x # element-wise arithmetic. this adds the first element from scores to the first element from x, then the second element from scores to the 2nd element from x,....
#element-wise arithmetic can be done with +, -, *, /, and ^

# what if we want to sum all of the elements in one vector
sum(scores)

# saving non-numeric objects in a vector 
players <- c("Rachel","Tatyana","Noah","Quentin","Aisha")

# Classes of variables: num, chr, int, log, etc 
# character vectors can be accessed in the same way as numerical vectors 
players[3]

#### Video: R tutorial 03 by ""####
# what if we want to make a spreadsheet with players names and their scores 
# spreadsheet-like data structures are called data frames. you can create a dataframe within R 
# how to read the below code: data.frame(column1name=c(), column2=c())
# you don't have to put a line break in there, but it helps make code more readable
data.frame(player=c("Rachel","Tatyana","Noah","Quentin","Aisha"),
           score=c(5,6,1,6,3))

# we made a dataframe with 2 columns: player and score 
data.frame(player=players, score=scores) # this gives us the same output as above, but it uses the vectors we already created

# the dataframe can be assigned to a variable 
dice <- data.frame(player=players, score=scores)
dice # we now see dice under "data" in the environment panel

# all columns in a data frame must be the same length. if they are different lengths, you'll get an error 


####Video: R tutorial 05: Inspecting a data frame ####

titanic <- read.csv("/Users/tessablack/Desktop/Downloads iCloud/titanic.csv")
View(titanic)

# How many data points (rows and columns) are there? 
# The environment panel tells us. Observation is a synonym for row, and variable is a synonym for column
nrow(titanic)
ncol(titanic)
dim(titanic) #dim stands for dimension. It spits out number of rows and columns in that order 

head(titanic) #head prints the first six rows
tail(titanic) #tail prints the last six rows

#structure
#str means structure. This will output that titanic is a data frame with 2208 rows and 11 columns 
# The column names are given on the left side after the $, and the data type is given after the colon. This will also print the first few objects in each column
str(titanic) 

names(titanic) # will only give us the column names

####Video: R tutorial 06: Extracting values from data frames ####
# to access elements of a vector, you use square brackets. It's similar for dataframes, but you have to use 2 numbers b/c they have rows and columns 

#Example: What if we are interested in the variable that is in row 2, column 4?
titanic[2,4]

# We can get a sequence of consecutive rows using a colon operator
titanic[2:5,4] # gives us rows 2, 3, 4, and 5 from column 4. This is the exact same output as line 186!!!
titanic[2:5,3:4]

#if you want all columns, leave the second argument blank
titanic[2:5,]

#What if we want only rows 2 and 4 with all columns? 
titanic[c(2,4),]

titanic[,c(1,3)] #prints all rows from columns 1 and 3. R doesn't print all of the rows because there are too many, but they are still part out of the output 

# You can also address columns by their titles 
titanic[,c("fam_name","gender")]

titanic[,"age"] # don't need the c function if you are only interested in one column 

# The dollar operator will only return a single column 
titanic$age

# When extracting a single column, the output is a vector
titanic$age[2:5] # Returns the second value in the column (vector) age. This gives the exact same output as line 166!!

# What if we only want the rows in a dataframe that correspond to 40 year old travelers? 
titanic[titanic$age==40,] 

titanic[titanic$class=="2nd",] # Returns the rows that correspond to second-class passengers. Let's save this as a vector 
sec_class <- titanic[titanic$class=="2nd",]

#Inspecting sec_class
nrow(sec_class) #So there were 271 2nd class passengers
ncol(sec_class)

# How many different values are in a given column, and what are the values? For example, how many different classes of passenger and crew are in the class column? 
unique(titanic$class) # This tells us there are 4 classes

#### Video: R tutorial 07: Appending and Removing columns from Data Frames ####
# We're going to convert the ticket cost to a decimal instead of the pounds/shilling/pence system using the formula Total = Pounds + (shillings/20) + (pence/240)

# Dividing all values in the column shl by 20
length(sec_class$shl) #this vector has length 271
sec_class$shl/20 #This is a vector divided by a single number. 
# In R, this is called vectorization. If 1 operon is a vector with multiple elements and the other operon is a single number, R carries out the operation for all elements in the longer vector

## MAKING A NEW COLUMN ####
# The output is in the console which isn't super useful, because we want this to be linked to the rest of the data such as passenger name. We can create a new column
sec_class$shl_to_pnd <- sec_class$shl/20 # Type name of data frame you want to make the column in, then $name of new column. Then the assignment operator <- 

# Calculating total price in pounds. R follows PEMDAS on its own, so we don't need to use parentheses 
sec_class$price <- sec_class$pnd+sec_class$shl/20+sec_class$pnc/240

## How to remove a column from a spreadsheet: getting rid of shl_to_pnd
# one way would be to make a subset of the data, omitting the shl_to_pnd column 
sec_class <- sec_class[, -12] # the minus sign tells R to remove the 12th column

# another way: using dollar notation and making column 12 NULL
sec_class$shl_to_pnd <- NULL #this is easier for this example because you don't have to count the columns 

#### Video: R tutorial 08: Logical Vectors ####

titanic[titanic$age==40,]
# A logical vector contains only elements that are true or false. The c function can be used to combine multiple logical elements into a vector
z <- c(TRUE, TRUE, FALSE, FALSE, TRUE)

# Logical vectors can be used to build subsets of other vectors that are equally long
View(players)
# We can subset the vector players by vector z, which will return only the players whose values of z are TRUE
players[z]

# Logical vectors are a natural outcome when we make comparisons 
scores ==6 # This outputs a logical vector of the same length as scores 
players[scores==6] #this will tell us the names of the players who had a score of 6

titanic[titanic$age==40,] # The expression before the comma refers to the rows. The blank space after the comma means that we keep all columns. In this example, we use the comparison operator == to return a logical vector that is TRUE only if titanic$age=40. This only keeps the rows where the person was exactly 40 years old. 