##### Exam 2 ####
library(tidyverse)
library(janitor)
library(skimr)
library(gapminder)
library(patchwork)

# Task 1: Read in the unicef data (10 pts) ####
unicef <- read_csv("unicef-u5mr.csv")

# Task 2: Get it into tidy format (10 pts) ####
# Note to self: every variable a column, every row an observation
unicef <- clean_names(unicef)
names(unicef)



# Task 3: Plot each country’s U5MR over time (20 points) ####
# Create a line plot (not a smooth trend line) for each country
# Facet by continent


# Task 4: Save this plot as LASTNAME_Plot_1.png (5 pts) ####

# Task 5: Create another plot that shows the mean U5MR for all the countries within a given continent at each year (20 pts) ####
# Another line plot (not smooth trendline)
# Colored by continent

# Task 6: Save that plot as LASTNAME_Plot_2.png (5 pts) ####

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


