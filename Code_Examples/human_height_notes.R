# SETUP ####
library(tidyverse)
library(readxl)
library(measurements)

# DATA ####
path <- "~/Documents/human_heights.xlsx"
dat <- read_xlsx(path)

# CLEAN ####
dat <- 
dat %>% 
  pivot_longer(everything(),
               names_to = "sex",
               values_to = "height") %>% 
  separate(height, into = c("feet","inches"),convert = TRUE) %>% 
  mutate(inches = (feet*12) + inches) %>% 
  mutate(cm=conv_unit(inches, from='in',to='cm'))

dat %>% 
  ggplot(aes(x=cm,fill=sex)) +
  geom_density(alpha=.5)
