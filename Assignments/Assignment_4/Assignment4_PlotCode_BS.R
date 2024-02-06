#### Assignment 4 ####
library(tidyverse)
library(gapminder)
library(ggimage)
library(gganimate)
library(patchwork)
hamsters <- read_csv(file = "./Assignments/Assignment_4/IU106_Social Behavior First and Last Five Minutes_Formatted_6-6-23_copy_BIOL3100.csv")

names(hamsters)

hamsters %>% 
  ggplot(aes(x = `Maternal Treatment`,y = `Investigation_Number of occurences`,fill=`Maternal Treatment`))+
  geom_col()+
  facet_wrap(~Sex)
View(plot_sex)
ggsave("./Assignments/Assignment_4/hamster_sex_plot.png",dpi = 200)

hamsters %>% 
  ggplot(aes(x = `Maternal Treatment`,y = `Investigation_Number of occurences`, fill = `Maternal Treatment`))+
  geom_col(aes(color = `Maternal Treatment`))+
  facet_wrap(~`First or Last Five Minutes`)

plot_both <- plot_sex+plot_trial.timing  

