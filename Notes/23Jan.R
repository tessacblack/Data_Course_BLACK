#### January 23

# Practice ####

# 1. Build a data frame from mtcars with only rows that have more than 4 cylinders (cyl)
View(mtcars)
many_cyl <- mtcars[mtcars$cyl>4,]

# 2. Pull out just the miles per gallon of those cars (mpg) and find the mean, min, and max
mean(many_cyl$mpg)
min(many_cyl$mpg)
max(many_cyl$mpg)

# Object types ####
## logical ####
c(TRUE, TRUE, FALSE)
## numeric #### 
1:10
## character ####
letters[3] #only need to give it one dimension
## integer #### 
c(1L,2L,3L) # need to end it with L so that R makes it an integer instead of numeric 
## dataframe ####
mtcars[rows,columns] #need to give data frames 2 dimensions when you want to access something from it in the format [rows, columns]
## factor #### 
# factor is a lot like a character. it is for categorical data, but it is stored differently. it stores the categories as numbers 
as.factor(letters) # the output is saying that everything in this set has to be found in one of these variables 
haircolors <- c("brown","blonde","black","red","red","black")
as.factor(haircolors) # very interesting. it only gives 4 levels but everything in haircolors fits into those four levels
# what if we want to add purple?
cc(as.factor(haircolors),"purple") #purple is left outside. it also turned the other values of haircolor into numbers which is annoying 
as.numeric(as.factor(haircolors),"purple") # this gace us values but left purple out 
as.character(as.factor(haircolors),"purple")

haircolors_factor <- as.factor(haircolors)
haircolors_factor[7] <- "purple" # NA bc you're trying to add purple when it doesn't match to any of the defined levels
levels(haircolors_factor) # prints the levels of a factor vector 



# Type conversions ####
1:5 # numeric, but what if we want to turn it into a character vector
as.character(1:5)
as.numeric(letters) # What numeric value does a letter have 
as.numeric(c("1", "b","35"))
x <- as.logical(c("true","t","F","False","T")) # This was able to do all of them except for t, because it's lowercase
sum(x) # Spit out NA. 
sum(TRUE)
TRUE+TRUE
FALSE+3
# This tells us that true and false are binary. Line 32 gave us NA because we have one NA value in there. 
NA+2
2+NA
# R can't solve anything that's missing data. It can't do anything with NA without being told 
sum(x,na.rm = TRUE) # na.rm asks if you want to remove all missing values. It's logical so you need to put TRUE so that R will ignore NA values 

NA # NA is the missing data code

# data frames ####
str(mtcars)
names(mtcars) # gives you the names of the columns as a character vector
# What if we want to convert them all to characters
# as.character(mtcars) # this didn't do what we wanted 
as.character(mtcars$mpg) # you can iterate through this with a forloop

mtcars[,"mpg"]

# the below for-loop assigns character version of every column over itself 
for(col in names(mtcars)){ 
  mtcars[,col] <- as.character(mtcars[,col])
}
# the names(mtcars) gives you the column title 

str(mtcars)
# We successfully changed the values in mtcars to characters 
data("mtcars") # resets built-in data frame 


# Convert all columns to character and write the new file to your computer 

path <- "./Data/cleaned_bird_data.csv"
df <- read.csv(path)
str(df)
for(i in names(df)){
  df[,i] <- as.character(df[,i])
}

# write the new file to your computer
write.csv(df,file="./Data/cleaned_bird_data_chr.csv")

# never change the original data file. that leads to mistakes. 

# We're gonna learn a different way to change all columns to characters 
data("mtcars")
str(mtcars)

# 'apply' family functions ####

apply(mtcars,2,as.character) # apply some function (in this case, as.character) 
#to every thing in a data set. apply(dataname, 1 or 2, function). 1 means apply to rows, 
#2 means apply to columns 

# you can use apply for as.character, as.factor, as.logical, etc. This code is easier to read and apply than the for loop, but for-loops are more customizable


lapply(list,function)
sapply(list,function)
vapply(list,function,FUN.VALUE=type,...)


# Packages ####
## tidyverse ####
library(tidyverse)
stats::filter() # the dplyr filter masks the stats filter, but you can get 
#around this by using packagename::function()
dplyr::filter()

# filter is for selecting rows in a data frame. We gave it a true/false condition
# and it printed the rows that are true
# filter helps us subseet data frames by rows 
?filter

mtcars %>% 
  filter(mpg>19)

mtcars %>% 
  filter(mpg>19 & vs==1)

# %>% %>% %>% %>%  # pipe, type with ctrl+shift+m
# the thing on the left side fo the pipe becomes the first argument to the thing on the right side of the pipe 
mtcars$mpg %>% mean()

abs(mean(mtcars$mpg))

mtcars$mpg %>% # this does the same thing as line 129, but it's much more readable
  mean() %>% 
  abs()
