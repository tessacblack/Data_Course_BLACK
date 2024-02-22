###########################
###### WEEK 5 NOTES #######
###########################

### Class 9: Tuesday February 6 and Class 10 Thursday February 8 ###

library(tidyverse)
library(gapminder)
library(ggimage)
library(gganimate)
library(patchwork)

### Package of the week ####
#ggmagnify

### Ugly plot contest ####
# axis breaks to fuck up your axes 
# ggalignment
# xkcd

## Class 9: Tuesday 6 Feb ####
# ggcoverage for component analysis 

df <- gapminder

gapminder %>% 
  ggplot(aes(x = lifeExp,
             y = gdpPercap))+
  #geom_line()
  geom_point(aes(color = continent))

# you can save a plot as an object. The object will contain all of the requirements
# to turn that data into the plot image
# you can add things to your plot object
# Plot 1
p <- df %>% 
  ggplot(aes(x = year, y = lifeExp, color = continent))+
  geom_point(aes(size = pop))+
  facet_wrap(~continent)+
  scale_color_viridis_d()

p.A <- df %>% 
  ggplot(aes(x = year, y = lifeExp, color = continent))+
  geom_point(aes(size = pop))+
  #facet_wrap(~continent)+
  scale_color_viridis_d()

p2 <- 
  p.A +
  facet_wrap(~continent)

p/p.A + plot_annotation(title = "Comparing with and without facets")


p.dark <- 
p+
  theme_dark()


# You can make a bunch of plots and stick them together in any order that you want using the patchwork package
p+p.dark
p/p.dark
(p+p.dark)/p.dark 
(p+p.dark)/p.dark + plot_annotation("MAIN_TITLE") # You can annotate plots, add titles, subtitles, etc
(p+p.dark)/p.dark + plot_annotation("MAIN_TITLE")+
  patchwork::plot_layout(guides = 'collect')


p3 <- 
  ggplot(df,
         aes(x=gdpPercap,y=lifeExp,color=continent))+
  geom_point(aes(size=pop))
  #geom_text(aes(label=country))

p3
df$year %>% range
# How do you only label countries you gaf about
df$country %>% unique
mycountries <- c("Venezuela","Rwanda","Nepal","Iraq","Afghanistan","United States")

df <- 
  df %>% 
  mutate(mycountries = case_when(country %in% mycountries ~ country)) # yay it worked

names(df)

p3 <- 
  ggplot(df,
         aes(x=gdpPercap,y=lifeExp,color=continent))+
  geom_point(aes(size=pop))+
  geom_text(aes(label=mycountries))

p3+
  transition_time(time = year)+
  labs(title='Year:{frame_time}')

anim_save("./gapminder_animation.gif")
ggsave("./plot_example.png",dpi = 200,plot=p3) # saves it as a png. After the comma, you can tell it 
# what plot to save, for example, you can tell it to save just p3. You can also tell it width and height




##### Class 10 Thursday 8 February #####

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

bp <- bp %>% 
  pivot_longer(starts_with("BP"),
               names_to = "visit",
               values_to = "bp") %>% # Visit is still weird, so we want to change it to visits 1, 2, 3
  mutate(visit = case_when(visit=="BP...8"~1,
                           visit=="BP...10"~2,
                           visit=="BP...12"~3))

# Homework: Finish mutating this (make all the white people the same), then do the same to heart rate, then full join both of them


#### homework
bp <- bp %>% 
  pivot_longer(starts_with("BP"),
               names_to = "visit",
               values_to = "bp") %>%
  mutate(visit = case_when(visit=="BP...8"~1,
                           visit=="BP...10"~2,
                           visit=="BP...12"~3)) #### TALK TO DR. ZHAN ABOUT ERROR

bp <- bp %>% 
  mutate(Race = case_when(
    Race %in% c("White","WHITE")~ "Caucasian",
    TRUE ~ Race
  ))

## Create hr dataframe
hr <- dat %>% 
  select(-starts_with("BP"))
View(hr)

hr <- hr %>% 
  pivot_longer(starts_with("HR"),
               names_to = "visit",
               values_to = "hr") %>%
  mutate(visit = case_when(visit=="HR...9"~1,
                           visit=="HR...11"~2,
                           visit=="HR...13"~3)) ## SAME FUCKIGN ERROR 
hr <- hr %>% 
  mutate(Race = case_when(
    Race %in% c("White","WHITE")~ "Caucasian",
    TRUE ~ Race
  ))


## Full join
full_join(hr,bp)
