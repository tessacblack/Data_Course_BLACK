#### 24 January studying/practice

# Video: Michael T. Gastner For-loops ####
c(2,4,7,6)+c(3,5,7,9) # for each element in this loop, R carries out an addition 

sample(6,size=10,replace=TRUE)

# general syntax of a for-loop
# for (i in v) { 
    #Command(s) to be repeated for all values i in v
      #}
for (i in c("Our","First","for-loop")){
    print(i)
}

# Navigating files from BIOL 3100 github ####
getwd()
list.files()[1:10] #Lists files in current working directory. Only list first 10 to save space

list.files(pattern="x") #just filenames that have "x" in them

# you can search in any directory in your computer by telling list.files() which "path" to search in
list.files(path="/Users/tessablack/Desktop/")[1:10]

list.files(path="/Users/tessablack/Desktop/",
           recursive=TRUE,
           pattern=".csv")[1:4]
# recursive = TRUE tells R to descend into subdirectories of a given path

# list.dirs will tell you the directories for files, but it doens't have a "pattern" function,
    # so if you wanted to use it with a pattern, you need to first do the list.files function and then save it as a vector
    # to use in list.dirs
