####### WEEK 3 NOTES ########

# Class 5 Tuesday, 23 Jan and Class 6 Thursday, 25 Jan #
#### January 23 ####

# Practice ####

# 1. Build a data frame from mtcars with only rows that have more than 4 cylinders (cyl) ####
View(mtcars)
many_cyl <- mtcars[mtcars$cyl>4,]

# 2. Pull out just the miles per gallon of those cars (mpg) and find the mean, min, and max ####
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
as.numeric(as.factor(haircolors),"purple") # this gave us values but left purple out 
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
# This tells us that true and false are binary. Line 35 gave us NA because we have one NA value in there. 
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
# While 2 means apply to columns 

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

mtcars$mpg %>% # this does the same thing as line 136, but it's much more readable
  mean() %>% 
  abs()

#### Thursday, January 25 #####
# Main focus: 

library(tidyverse)
library(palmerpenguins)
# %>% is a 'pipe'

# subset the penguins data frame to only those observations where 
# bill_length_mm>40

penguins %>% 
  filter(bill_length_mm>40) # So if you pipe penguins to filter, it just wants a true/false statement

# what if we want bill length > 40 and only females?
penguins %>% 
  filter(bill_length_mm>40 & sex=="female") 
# Find mean body mass of the above
female_large_bill <- penguins %>% 
  filter(bill_length_mm>40 & sex=="female") # assign the subset we want to a new object
female_large_bill$body_mass_g %>% mean # use dollar sign on that object

# find mean body mass of female long-beaked penguins
penguins %>% 
  filter(bill_length_mm>40 & sex=="female") %>% # pass this data set to pluck
  pluck("body_mass_g") %>% # 'pluck' lets us pull out columns by name. This is a numerical vector
  mean

# a grouped dataframe is called a tibble
# do the same, but for each species separately, and find min,max,stdev,mean
penguins %>% 
  filter(bill_length_mm>40 & sex=="female") %>%
  group_by(species) %>% #groupby isn't that useful unless it's followed by summarize. Groupby creates groups but doesn't do anything with it 
  summarize(mean_body_mass=mean(body_mass_g),# summarize will create a new dataframe for us with a new column called mean_body_mass
            min_body_mass=min(body_mass_g),
            max_body_mass=max(body_mass_g),
            sd_body_mass=sd(body_mass_g),
            N=n()) # number of rows (number of observations). There were only 7 Adelie penguins that matched our bill length and sex conditions
# the above created another variable type called dbl, which is the same as single/numeric
# we just summarized the fuck out of our data set. since we grouped by specices, all 
# of the summary stats we generate will come out by species 
# this table is equivalent to a pivot table in excel, i guess

penguins %>% 
  filter(bill_length_mm>40 & sex=="female") %>%
  group_by(species) %>% 
  summarize(mean_body_mass=mean(body_mass_g),
            min_body_mass=min(body_mass_g),
            max_body_mass=max(body_mass_g),
            sd_body_mass=sd(body_mass_g),
            N=n()) %>% 
  arrange(mean_body_mass) # arranging our data set. numeric gets arranged by default by lowest to highest, gentoos on bottom

penguins %>% 
  filter(bill_length_mm>40 & sex=="female") %>%
  group_by(species) %>% 
  summarize(mean_body_mass=mean(body_mass_g),
            min_body_mass=min(body_mass_g),
            max_body_mass=max(body_mass_g),
            sd_body_mass=sd(body_mass_g),
            N=n()) %>% 
  arrange(desc(mean_body_mass)) # now it goes highest to lowest, gentoos on top

#write this out
penguins %>% 
  filter(bill_length_mm>40 & sex=="female") %>%
  group_by(species) %>% 
  summarize(mean_body_mass=mean(body_mass_g),
            min_body_mass=min(body_mass_g),
            max_body_mass=max(body_mass_g),
            sd_body_mass=sd(body_mass_g),
            N=n()) %>% 
  arrange(desc(mean_body_mass)) %>% 
  write_csv("./Data/penguin_summary.csv")

# Since we were piping this to write_csv, we don't have to tell it what to write, that's already taken care of. 

# what if we want to group by species and by island
penguins %>% 
  filter(bill_length_mm>40 & sex=="female") %>%
  group_by(species,island) %>% # use commas to separate grouping columns
  summarize(mean_body_mass=mean(body_mass_g),
            min_body_mass=min(body_mass_g),
            max_body_mass=max(body_mass_g),
            sd_body_mass=sd(body_mass_g),
            N=n()) %>% 
  arrange(desc(mean_body_mass)) %>% 
  write_csv("./Data/penguin_summary.csv")


# find the fattie penguins body_mass>5000
# count how many are male and how many are female 
# return the max body mass for males and females 
# bonus: add new column to penguins that says whether bodymass>5000

penguins %>% 
  filter(body_mass_g>5000) %>% 
  group_by(sex) %>% 
  summarize(N=n(),
            max_fattie=max(body_mass_g))

penguins$body_mass_g > 5000

penguins %>% 
  mutate(fattie = body_mass_g>5000)

# what if we want it to say fattie instead of true/false
x <- 
  penguins %>% 
  mutate(fatstatus = case_when(body_mass_g > 5000 ~ "fattie",
                               body_mass_g <= 5000 ~ "skinny")) # case when only works inside of mutate

iris %>% 
  mutate(sepal.area=Sepal.Length*Sepal.Width)

# filter: selects rows
# group by: makes groups
# mutate: changes columns 


# Intro to plotting

x %>%
  filter(!is.na(sex)) %>% 
  ggplot(mapping = aes(x=body_mass_g,
                       y=bill_length_mm,
                       color = fatstatus,
                       shape = fatstatus)) + 
  geom_point() +
  geom_smooth() + 
  scale_color_manual(values=c("turquoise","pink")) +
  #scale_color_viridis_d(option = 'turbo') + 
  theme_light()

# ggplot really wants a dataframe. it also wants to know how to map the variables onto the plot 'mapping'
# + starts adding layers to the plot 


# Pack of the week 
ggmap