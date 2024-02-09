# Thursday, February 8 Notes ####

library(tidyverse)
library(gapminder)
library(ggimage)
library(gganimate)
library(patchwork)

df <- read.csv("./Data/wide_income_rent.csv")

# plot rent prices for each state, state on x axis, rent on y axis, bar chart
# aesthetics want a column name in ggplot 
# so this is a messy af dataset. We need state, rent, and income to be a column since those are the three variables we have here
# it's very common for one variable to be stretched out into multiple columns like state is here
# We want this dataset to have 3 columns & 52 rows
# We need to transpose it - transpose function is just t()
df2 <- t(df) # so this is a matrix and not a dataframe
# Inside of a matrix, everything has to be the same, so we don't have column names anymore 

df2 <- t(df) %>% as.data.frame # better, but we still need a new column for state and we need to get rid of the first row
# could take the row names and add a column called state 

df2 <- df2[-1,] # got rid of row 1
df2$State <- row.names(df2)
# Now we need to change V1 and V2 to rent and income
names(df) <- c("rent","income","State") # This overrides the names and changes them to what we want
# We've actually fucked the columns now b/c we assigned rent to the income column and income to the row
# Dr. Z said this process sucks, so use tidyverse to do this instead 

# pivot.longer is taking a wide dataset and making it longer. You want to pivot longer when there's a single variable taking up multiple columns


df %>% 
  pivot_longer(-variable,names_to = "state",values_to = "amount") %>% # Tell it which columns should be one column. We want all of the current columns to be one column except for the "variable" column
  ggplot(aes(x=state,y=amount,color=variable))+
  geom_point(size=3)

# We want to fix the variable column 
df %>% 
  pivot_longer(-variable,names_to = "state",values_to = "amount") %>% 
  pivot_wider(names_from = variable,
              values_from = amount) %>%  # from here, you can just go straight to ggplot
  ggplot(aes(x=state,y=rent))+
  geom_col() +
  theme(axis.text.x = element_text(angle=90,hjust=1,vjust=0.5,size=6))

# if one variable is across multiple columns...pivot longer 
# if multiple variables are in a single column....pivot wider

# You never ever touch a raw data file. everything you do to transform a dataset HAS 
#to be done in R so that you have a record of what you've done and so that it's reproducable

table1 # this is a built-in dataset 
# Note to self: What the fuck is a tibble I'm so behind in this class 
# This is a tidy dataset 
# In a tidy dataset, every row is one observation. 

# When you work with a dataset, you always want to ask: What are my actual variables? What are my observations? 

table2 # Same data, column 3 is fucked up. Cases and population should be 2 different variables 

# TasK: Take table 2 and make it look like table 1
table2 %>% 
  pivot_wider(names_from = type, values_from = count)

table3 # Rate column. And it's a character. So here we have a column that within it has two variables

table3 %>% 
  separate(rate,into = c("cases","population"))

# Separate will separate where there's a non alphanumeric character in a column

# Table 4 is split into two tables: 4a and 4b
table4a # cases. By itself, table4a isn't even tidy
table4b # population. Also not even tidy


# Fix table 4a by itself
x <- table4a %>% 
  pivot_longer(-country,names_to = "year",
               values_to = "cases")
# Fix table 4b by itself 
y <- table4b %>% 
  pivot_longer(-country,names_to = "year",
               values_to = "population")
x
y

# To join two dataframes, you need at least one common column name to join them by. That column has to have the same name and same spelling

full_join(x,y) # By default, it wll find the common column. In the console, it also will tell you what it joined by 

table5
# the package gods have fucked the combine function and it no longer exists, so we have to use mutate for this 
table5 %>%
  separate(rate, into = c("cases","population"),convert = TRUE) %>% # Initially, when we first just separated, these were all character vectors. Convert changed it to integer
  mutate(year = paste0(century, year) %>% as.numeric()) %>% 
  select(-century)




library(readxl)
dat <- read_xlsx("./Data/messy_bp.xlsx")
View(dat)
# Each blood pressure column has 2 variables in it (systolic over diastolic)
# Visit is a variable spread across 3 merged columns so kind of 6 columns for one variable 
# The variables aren't the same in the Race column (White, WHITE, Caucasian)
# Because they put a title, we have a ton of NAs once we get it into R 
# What if we change the way we read it in 

dat <-  read_xlsx("./Data/messy_bp.xlsx", skip = 3)
View(dat) # this is much better, but we did lose the visits. 
# Heart rate and BP columns have become weird as well, because R cannot have multiple columns with the same name 

bp <- 
  dat %>% 
  select(-starts_with("HR")) # Create a new dataset with everything except for the columns that start with HR 
View(bp)

bp %>% 
  pivot_longer(starts_with("BP"),
               names_to = "visit",
               values_to = "bp") %>% # Visit is still weird, so we want to change it to visits 1, 2, 3
  mutate(visit = case_when(visit=="BP...8"~1,
                           visit=="BP...10"~2,
                           visit=="BP...12"~3))

# Homework: Finish mutating this, then do the same to heart rate, then full join both of them