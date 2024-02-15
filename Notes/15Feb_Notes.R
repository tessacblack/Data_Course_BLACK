################################
####### Thursday, Feb 15 #######


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

