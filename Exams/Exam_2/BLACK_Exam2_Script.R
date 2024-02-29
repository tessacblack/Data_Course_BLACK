##### Exam 2 ####
library(tidyverse)
library(janitor)
library(skimr)
library(gapminder)
library(patchwork)
library(easystats)

# Task 1: Read in the unicef data (10 pts) ####
unicef <- read_csv("unicef-u5mr.csv")

# Task 2: Get it into tidy format (10 pts) ####

# Clean names
unicef <- clean_names(unicef)
names(unicef)

# Columns: country, u5mr, year. remove "u5mr_" from year column
clean <- unicef %>% 
  pivot_longer(starts_with("u5mr_"),
               names_to = "year",
               values_to = "u5mr") %>% 
  rename(country = country_name) %>% 
  mutate(year = str_remove(year, "u5mr_"))


# Task 3: Plot each country’s U5MR over time (20 points) ####
# Create a line plot (not a smooth trend line) for each country
# Facet by continent
plot1 <- 
  clean %>% 
  ggplot(aes(x = year, y = u5mr, group = country))+
  geom_line()+
  facet_wrap(~continent)+
  scale_x_discrete(breaks = c(1960, 1980, 2000))+
  theme_minimal()
print(plot1)  

# Task 4: Save this plot as LASTNAME_Plot_1.png (5 pts) ####
ggsave("./BLACK_Plot_1.png", plot = plot1)

# Task 5: Create another plot that shows the mean U5MR for all the countries within a given continent at each year (20 pts) ####
# Another line plot (not smooth trendline)
# Colored by continent

task5 <- clean %>% 
  group_by(year, continent) %>% 
  summarize(meanu5mr = mean(u5mr, na.rm = TRUE))

plot2 <- task5 %>% 
  ggplot(aes(x = year, y = meanu5mr,
             color = continent,
             group = continent))+
  geom_line(linewidth= 1.5)+
  scale_x_discrete(breaks = c(1960, 1980, 2000))+
  theme_minimal()
print(plot2)


# Task 6: Save that plot as LASTNAME_Plot_2.png (5 pts) ####
ggsave("./BLACK_Plot_2.png", plot = plot2)


# Task 7: Create three models of U5MR (20 pts) ####
# mod1 should account for only Year
# mod2 should account for Year and Continent
# mod3 should account for Year, Continent, and their interaction term




# Task 8: Compare the three models with respect to their performance ####
# Your code should do the comparing
# Include a comment line explaining which of these three models you think is best


# Task 9: Plot the 3 models’ predictions like so: (10 pts) ####



# Task 10: BONUS - Using your preferred model, predict what the U5MR would be for 
# Ecuador in the year 2020. The real value for Ecuador for 2020 was 13 under-5 
# deaths per 1000 live births. How far off was your model prediction???


