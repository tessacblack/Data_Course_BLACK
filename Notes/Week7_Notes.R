############################
####### WEEK 7 NOTES #######
############################

library(tidyverse)
library(janitor)
library(patchwork)
library(skimr)
library(readxl)


#### Tuesday February 20 ####
#library(colorblindr) # Show and tell
# Since it's not in cran, you have to download it from github
#remotes::install_github("wilkelab/cowplot")
#install.packages("colorspace", repos = "http://R-Forge.R-project.org")
#remotes::install_github("clauswilke/colorblindr")
#library(colorblindr)



### Back to the blood pressure dataset. How could we extract the visit information and have it link with the measurements
dat <-  read_xlsx("./Data/messy_bp.xlsx", skip = 3)

bp <- 
  dat %>% 
  select(-starts_with("HR"))

names(bp)
# How can we change anywhere there is BP to visit 1,2,3, etc
n.visits <- bp %>% 
  select(starts_with("BP")) %>% # remember that starts_with only works inside of select
  length()
1:n.visits # Gives you 1 through the number of BP columns there are 
paste0("visit",1:n.visits) # This gives us our nice column names that we want to trade out 

# Which column numbers start with BP
which(grepl("^BP",names(bp))) # Which is a special function that, when you give it a 
# true/false question, it tells you which ones were true by number
# This tells us where we want to put our nice column names 

names(bp)[which(grepl("^BP",names(bp)))] <- paste0("visit",1:n.visits) 
# Which of the names of bp start with BP # Assigns the nice new column names 
# I don't fucking understand this 

# But from here, we can't pivotlonger on "starts with BP" anymore, so we need to do starts with visit
# It's also going to break our mutate 

# This is where everything started to get ugly with pivot and mutate. If they were to add
# more visits to this dataset, then you would have to rewrite your code
bp <- 
  bp %>% 
  pivot_longer(starts_with("visit"),
               names_to = "visit",
               values_to = "bp",
              names_prefix = "visit",
              names_transform = as.numeric) # names prefix removes the word "visit" 
                    #and tries to turn it into a number (which it did)


hr <- 
  dat %>% 
  select(-starts_with("BP"))

names(hr)[which(grepl("^HR",names(hr)))] <- paste0("visit",1:n.visits) 


hr <- hr %>% 
  pivot_longer(starts_with("visit"),
               names_to = "visit",
               values_to = "hr",
               names_prefix = "visit",
               names_transform = as.numeric)

df <- full_join(bp,hr)

df <- df %>% 
  clean_names()

# Can practice cleaning with bird measurements, datasaurusdozen and datasaurusdozenwide, 
# specifically practice with facultysalaries, landdata states, juniper oils