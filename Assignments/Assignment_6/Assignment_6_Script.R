######################
#### Assignment 6 ####
######################

library(tidyverse)
library(stringr)
library(skimr)
library(janitor)
library(patchwork)
library(gganimate)

dat <- read_csv("../../Data/BioLog_Plate_Data.csv")

# Task 1: Cleans this data into tidy (long) form ####
# variables: Sample ID, rep, well, dilution, substrate, time, absorbance
dat <- dat %>% 
  pivot_longer(starts_with("Hr_"),
    names_to = "time",
    values_to = "absorbance") %>% 
  mutate(time = str_remove(time, "Hr_")) %>% 
  mutate(time = as.numeric(time))

dat <- clean_names(dat) 

# Task 2: Creates a new column specifying whether a sample is from soil or water ####
unique(dat$sample_id)
dat <- dat %>% 
  mutate(sample_source = case_when(
    sample_id %in% c("Clear_Creek","Waste_Water") ~ "water",
    sample_id %in% c("Soil_1","Soil_2") ~ "soil"))

# Task 3: Generates a plot that matches this one ####
dil0.1 <- dat %>% 
  filter(dilution == 0.1)


dil0.1 %>% 
  ggplot(aes(x = "time",
             y = "absorbance"))+
  geom_point()+
  geom_line(aes(color = sample_source))+
  facet_wrap(~substrate, scales = 'free')


dil0.1 %>%
  ggplot(aes(x = time, 
             y = absorbance, 
             color = sample_source)) +
  geom_smooth(se = FALSE) +
  #geom_point() +
  facet_wrap(~substrate) +
  theme_minimal() +
  labs(x = "Time", y = "Absorbance", color = "Type")

# Task 4: Generates an animated plot that matches this one ####
