###########################
#                         #
#    Assignment Week 3    #
#                         # 
###########################

# Instructions ####
# Fill in this script with stuff that we do in class.
# It might be a good idea to include comments/notes as well so you remember things we talk about
# At the end of this script are some comments with blank space after them
# They are plain-text instructions for what you need to accomplish.
# Your task is to write the code that accomplished those tasks.
# Then, make sure to upload this to both Canvas and your GitHub repository
# YOUR REMAINING HOMEWORK ASSIGNMENT (Fill in with code) ####

# 1.  Get a subset of the "iris" data frame where it's just even-numbered rows
seq(2,150,2) # here's the code to get a list of the even numbers between 2 and 150
iris[seq(2,150,2),]
even_only <- iris[seq(2,150,2),] # Saved as object for myself just in case 


# 2.  Create a new object called iris_chr which is a copy of iris, except where every column is a character class
iris_chr <- as.data.frame(lapply(iris, as.character))
str(iris_chr) # Double-checking

# 3.  Create a new numeric vector object named "Sepal.Area" which is the product of Sepal.Length and Sepal.Width
Sepal.Area <- iris$Sepal.Length * iris$Sepal.Width


# 4.  Add Sepal.Area to the iris data frame as a new column
iris$Sepal.Area <- Sepal.Area


# 5.  Create a new dataframe that is a subset of iris using only rows where Sepal.Area is greater than 20 
      # (name it big_area_iris)
big_area_iris <- iris[iris$Sepal.Area>20,]


# 6.  Upload the last numbered section of this R script (with all answers filled in and tasks completed) 
      # to canvas
      # I should be able to run your R script and get all the right objects generated

