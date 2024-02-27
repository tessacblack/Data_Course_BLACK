# Assignment 6 ####
library(tidyverse)
library(patchwork)
library(readxl)
library(janitor)

dat <- read_csv("../../Data/BioLog_Plate_Data.csv")

# Cleans this data into tidy (long) form ####
# Creates a new column specifying whether a sample is from soil or water

dat <- 
  dat %>% 
  clean_names()

dat$sample_id %>% 
  unique()

dat <- 
  dat %>% 
  mutate(type = case_when(sample_id == "Clear_Creek" | sample_id == "Waster_Water" ~ "Water",
                          TRUE ~ "Soil"))

dat <- dat[, c("sample_id", "type", "rep", "well", "dilution", "substrate", "hr_24", 'hr_48', "hr_144")]


dat <- 
  dat %>% 
  clean_names() %>% 
  pivot_longer(starts_with("hr_"),
               names_to = "hour",
               values_to = "absorption",
               names_prefix = "hr_",
               names_transform = as.numeric)


# Generates a plot that matches this one (note just plotting dilution == 0.1): ####

dat %>% 
  filter(dilution == 0.1) %>% 
  ggplot(aes(x = hour, y = absorption, color = type)) +
  geom_smooth(se = FALSE) +
  facet_wrap(~substrate) +
  theme(strip.background = element_rect(fill = "white"),
        text = element_text(size = 5)) +
  ggtitle("Just Dilution 0.1")


# second plot ####
# Generates an animated plot that matches this one (absorbance values are mean of all 3 replicates for each group):
# This plot is just showing values for the substrate “Itaconic Acid”


dat %>% 
  ggplot(aes(x = hour, y = mean(absorption))) +
  geom_point() +
  facet_wrap(~substrate ~dilution)






