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
is.vector(hi). #TRUE

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

titanic <- read.csv("/Users/tessablack/Desktop/Downloads")