##### Cleaning data practice/homework ####
library(tidyverse)
library(gapminder)
library(janitor)
library(skimr)
library(patchwork)
library(readxl)

# From the Hadley paper ####
billboard <- read_csv("./Data/Hadley_paper/data/billboard.csv")
skim(billboard)
billboard <- billboard %>% 
  clean_names() %>% 
  pivot_longer(starts_with("x",),
               names_to = "week",
               values_to = "position") %>%
  str_remove("x",
             "th",
             "st",
             "rd",
             "nd",
             "_week")
