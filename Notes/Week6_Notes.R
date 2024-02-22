############################
####### WEEK 6 NOTES #######
############################

#########################################
#### Class 11: Tuesday February 13 ####
library(tidyverse)
library(readxl)

# Data entry rules: one variable per column, one observation per row 
#read_xlsx("./Data/Data_Entry_Case_Study.xlsx")

# When setting up a spreadsheet for data collection, you can format your spreadsheet in a tidy way
# You can also format the cells, but you have to do it before you put in any data into that column 
# In excel: Data -> validation will allow you to set what values are allowed to be input into a column
  # This allows you to prevent people from misspelling stuff or putting in spaces before/after
  # Data validity lets you say "here are the only two things allowed in this column" 
  # Excel will not let you spell something wrong after that 
# Tools -> protection -> protect sheet ---> prevents people from editing selected cells
  # password protects highlighted cells and prevents them from being modified 


#### Last week bp
dat <-  read_xlsx("./Data/messy_bp.xlsx", skip = 3)

bp <- 
  dat %>% 
  select(-starts_with("HR")) # Create a new dataset with everything except for the columns that start with HR 
View(bp)

hr <- dat %>% 
  select(-starts_with("BP"))

## Today in class: fixing systolic and diastolic
bp <- bp %>% 
  pivot_longer(starts_with("BP"),
               names_to = "visit",
               values_to = "bp") %>%
  mutate(visit = case_when(visit=="BP...8"~1,
                           visit=="BP...10"~2,
                           visit=="BP...12"~3)) %>% 
  separate(bp, into = c("systolic","diastolic"))

hr <- hr %>% 
  pivot_longer(starts_with("HR"),
               names_to = "visit",
               values_to = "hr") %>%
  mutate(visit = case_when(visit=="HR...9"~1,
                           visit=="HR...11"~2,
                           visit=="HR...13"~3))

df <- full_join(bp,hr)


# cleanup stuff 
# cleaning up column names to be sane and not evil
library(janitor) # new package
#janitor::clean_names()

df <- df %>% 
  clean_names() #clean names really wants a dataframe

make_clean_names(c("# of bacteria","% caucasian")) # make_clean_names() changes a character vector.
# tries to fix special characters, makes spaces underscores, makes everything lowercase

# dealing with the race column
df$race %>% unique # what are all of the options for race

str_squish # Detects all of the excess spaces at the end of an entry and removes the spaces
# You can also do things like str_to_lower str_to_upper to make all entries lower/uppercase
df <- df %>% 
  mutate(race = case_when(race == "Caucasian" | race == "WHITE" ~ "White", # The straight line | means OR 
                          # the above will give us a bunch of NAs wherever something isn't Caucasian or WHITE, so you have to use the shortcut TRUE ~ race
                          TRUE ~ race)) # This means that in all other cases, use whatever is in the column

# Let's make a birth date. This will be a new class. (We could also pipe the above, but my notes will get in the way)
# Universally accepted date format: Year-Month-Day 2024-02-03 means feb 3 2024
# Then that's followed by the time so
"2024-02-03 12:30:00"

df %>% 
  mutate(birthdate = paste(year_birth,month_of_birth,day_birth,sep = "-") %>% # this almost worked, but it's still a chr vector
  as.POSIXct()) %>% # This is the universal time code 
  str

# Get rid of year birth, day birth, month birth, fix systol and diastol to numeric 
df$hispanic %>% unique # slay
df$sex %>% unique # slay

df <- df %>% 
  mutate(race = case_when(race == "Caucasian" | race == "WHITE" ~ "White",
                          TRUE ~ race)) %>% 
  mutate(birthdate = paste(year_birth,month_of_birth,day_birth,sep = "-") %>%
           as.POSIXct()) %>%
  mutate(systolic = systolic %>% as.numeric(),
         diastolic = diastolic %>% as.numeric()) %>% 
  select(-pat_id,-month_of_birth,-day_birth,-year_birth) %>% 
  mutate(hispanic = case_when(hispanic == "Hispanic" ~ TRUE,
                              TRUE ~ FALSE)) # TRUE on this line means "Everything else" FALSE
# so this is cleaned. jesus h. christ
# Now you could plot this 

df %>% 
  ggplot(aes(x = visit, y = hr,color = sex))+
  geom_path()+
  facet_wrap(~race)

# What if we want to do this with BP? But we separated them into two columns 
df %>% 
  ggplot(aes(x = visit,color = sex))+
  geom_path(aes(y = systolic))+
  geom_path(aes(y = diastolic))+
  facet_wrap(~race)
# Our dataset isn't set up for us to be able to plot systolic and diastolic. We need a column that says 
# whether it's systolic or diastolic 

# Fix BP (could also do this in the pipeline above, but I'm not for the sake of my notes)
df <- df %>% 
  pivot_longer(cols = c("systolic","diastolic"),names_to = "bp_type",
               values_to = "bp")
# Now it's clean again


df %>% 
  ggplot(aes(x = visit, y = bp, color = bp_type))+
  geom_path()+
  facet_wrap(~race)

# Homework: start with a fresh R script. Do not look at the BP cleaning that we've 
# done so far, and clean the BP data again from scratch. DO NOT LOOK AT PREVIOUS CODE. 
# Once you can make the above plot, then go compare what you did 


###########################################
####### Class 12: Thursday, Feb 15 #######
###########################################

# First thing we did was go over the exam 
df <- read_csv("./Data/Bird_Measurements.csv")
# Pivot longer situation, but we have several pivot longers we're going to have to do, also, you can't pivot longer with all of these columns
# For the sake of this class, we're going to fuck all of the N columns since they're not useful and there's so much missing data

library(skimr) # Basically has one function, it just skims the dataframe and tells you a lot of useful things about it very quickly
skim(df)
# N_missing: how many missing variables are in that column
# complete_rate: how complete it is 
# whitespace: how many weird spaces do you have 


## What needs to happen to this dataset?
# Make 3 separate dataframes (one for each sex), then pivot, then stick em back together 


df <- df %>% 
  clean_names()
names(df)

females <- df %>% 
  select(starts_with("f_"),species_number,species_name,english_name,family,mating_system,clutch_size,egg_mass,-(ends_with("n"))) %>% 
  mutate(sex="female")
names(females) <- names(females) %>% str_remove("f_")




#females <- df %>% 
  #select(starts_with("f_"),species_number,species_name,english_name,family,mating_system,clutch_size,egg_mass,-(ends_with("n"))) %>% 
 # mutate(sex="female") %>% 
 # pivot_longer(starts_with("f_"),
            #   names_to = "measure_type",
            #   names_prefix = "f_",
           #    values_to = "measurement")
  
males <- df %>% 
  select(starts_with("m_"),species_number,species_name,english_name,family,mating_system,clutch_size,egg_mass,-(ends_with("n"))) %>% 
  mutate(sex="male") 
names(males) <- names(males) %>% str_remove("m_")

unsexed <- df %>% 
  select(starts_with("unknown"),species_number,species_name,english_name,family,mating_system,clutch_size,egg_mass,-(ends_with("n"))) %>% 
  mutate(sex="unknown")
names(unsexed) <- names(unsexed) %>% str_remove("unsexed_")


cleaned <- males %>% 
  full_join(females) %>% 
  full_join(unsexed)

