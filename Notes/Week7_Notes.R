############################
####### WEEK 7 NOTES #######
############################

library(tidyverse)
library(janitor)
library(patchwork)
library(skimr)
library(readxl)


#### Class 13: Tuesday February 20 ####
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



####### Class 14: Thursday Feb 22 #####
# Package highlight: hexsticker. makes hexagon stickers 
# Other package highilght: measurements 
install.packages("lubridate")
library(lubridate)
x <- c(12,31,44)
library(measurements)
measurements::conv_unit(x, from = 'inch', to = 'ft')
measurements::conv_unit(x, from = 'inch', to = 'parsec')

# I started my voice recording at 10:09 when we were reading in Chandler's dataset
#file.copy("original file path", "file new path")

path <- "./Data/CW_CameraData_2019.xlsx"
sites <- c("South Oak Spring Site 2", "North Oak Spring Site 2")

sites[1] %>% str_replace_all(" ","_") # replaces space with underscore

# trap days still isn't read in, and it needs to be its own column as well. He inserted this code above 

South_Oak_Spring_Site_2 <- 
  read_trap_data(path = path, 
               sheet = sites[1],
               range1 = "B17:I17",
               range2 = "A2:I12")

trap_days <- read_xlsx(path,sheet = sites[1], range = "B17:I17",col_names = FALSE)

South_Oak_Spring_Site_2 <- 
  read_xlsx(path,sheet = sites[1], range = "A2:I12") %>% 
  clean_names() %>% 
  pivot_longer(-species,
               names_to = "month",
               values_to = "obs_count") %>% 
  mutate(site = sites[1],
         month = str_to_sentence(month),
         species = str_to_sentence(species)) #this makes it sentence case, so only the first letter will be capitalized

South_Oak_Spring_Site_2 <- 
  South_Oak_Spring_Site_2 %>% 
full_join(data.frame(month = South_Oak_Spring_Site_2$month %>% unique,
                     trap_days = trap_days[1,] %>% as.numeric()))


# We're going to make a function to do this for us so we don't have to copy and 
#paste this code for every single spreadsheet tab

sites <- c("South Oak Spring Site 2", 
           "North Oak Spring Site 1",
           "Oak_Spring",
           "North Tickville Site 1",
           "South Tickville Site 3",
           "Tickville",
           "Redwood Road Underpass",
           "Water Fork Rose Canyon Spring")


North_Oak_Spring_Site_1 <- 
read_trap_data(path = path, 
               sheet = sites[2],
               range1 = "B15:I15",
               range2 = "A2:I12")

Oak_Spring<- 
  read_trap_data(path = path, 
                 sheet = sites[3],
                 range1 = "B18:I18",
                 range2 = "A2:I15")


North_Tickville_Site_1<- 
  read_trap_data(path = path, 
                 sheet = sites[4],
                 range1 = "B14:I14",
                 range2 = "A2:I11")

South_Tickville_Site_3<- 
  read_trap_data(path = path, 
                 sheet = sites[5],
                 range1 = "B13:I13",
                 range2 = "A2:I10")

Tickville<- 
  read_trap_data(path = path, 
                 sheet = sites[6],
                 range1 = "B14:I14",
                 range2 = "A2:I11")

Redwood_Road_Underpass<- 
  read_trap_data(path = path, 
                 sheet = sites[7],
                 range1 = "B15:F15",
                 range2 = "A2:F12")

Water_Fork_Rose_Canyon_Spring<- 
  read_trap_data(path = path, 
                 sheet = sites[8],
                 range1 = "B21:J21",
                 range2 = "A2:J16")


sites %>% str_replace_all(" ","_")

# You could type all of them and full join them all 

full <- 
  South_Oak_Spring_Site_2 %>% 
  full_join(North_Oak_Spring_Site_1) %>% 
  full_join(Oak_Spring) %>% 
  full_join(North_Tickville_Site_1) %>% 
  full_join(South_Tickville_Site_3) %>% 
  full_join(Tickville) %>% 
  full_join(Redwood_Road_Underpass) %>% 
  full_join(Water_Fork_Rose_Canyon_Spring)
View(full)
