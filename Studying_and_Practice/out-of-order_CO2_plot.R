# I need to make a plot of CO2 uptake in plants. My boss wants to know which region, 
# which CO2 concentration, and at what temperature, plants take up the most CO2.

# So guess what... I wrote the code and was getting ready to send off my plot, but I decided
# to take a break to play Mario Kart. My dog, naturally, came by while I wasn't looking
# and re-arranged my code. He also told me that he introduced a single error 
# in the plotting function in order to mess with me even more.

# Please put it back in order for me so that it will generate a plot of mean CO2 uptake
# for each of those independent variables. You'll need to find the plotting error as well.

# load tidyverse packages
library(tidyverse)

# load data
data("CO2")

# calculate within-group means in unknown order
means <- CO2 %>%
  group_by(Type,Treatment,conc) %>%
  summarise(MeanUptake = mean(uptake))

# Plotting code in unknown order
ggplot(means, aes(x=conc,y=MeanUptake,color=Treatment)) +
  geom_point() +
  facet_grid(~Type)

# that was easy 