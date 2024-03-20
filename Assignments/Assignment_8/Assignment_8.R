########################
##### Assignment 8 #####
########################

library(tidyverse)
library(janitor)
library(easystats)
library(caret)
library(broom)
library(modelr)
library(skimr)

# 1. loads the “/Data/mushroom_growth.csv” data set
df <- read_csv("./mushroom_growth.csv")
df <- janitor::clean_names(df)
names(df)
skim(df)

# 2. creates several plots exploring relationships between the response and predictors ####

# Relationship between light and growth rate
df %>% 
  ggplot(aes(x = light, y = growth_rate))+
  geom_point()

# Relationship between species and growth rate
df %>% 
  ggplot(aes(x = species, y = growth_rate, color = species))+
  geom_point()

# Relationship between humidity and growth rate
df %>% 
  ggplot(aes(x = humidity, y = growth_rate))+
  geom_point()

# Relationship between nitrogen and growth rate
df %>% 
  ggplot(aes(x = nitrogen, y = growth_rate))+
  geom_point()

# Relationship between temperature and growth rate
df %>% 
  ggplot(aes(x = temperature, y = growth_rate))+
  geom_point()

# 3.defines at least 4 models that explain the dependent variable “GrowthRate” ####
mod1 <- lm(data = df, formula = growth_rate ~ light)
summary(mod1)

mod2 <- lm(data = df, formula = growth_rate ~ light * humidity)
summary(mod2)

mod3 <- lm(data = df, formula = growth_rate ~ light * humidity * nitrogen)
summary(mod3)

mod4 <- lm(data = df, formula = growth_rate ~ light * humidity * nitrogen * temperature)
summary(mod4)

mod5 <- lm(data = df, formula = growth_rate ~ light * humidity * nitrogen * temperature * species)
summary(mod5)

parameters::compare_models(mod1, mod2, mod3, mod4, mod5)

compare_performance(mod1, mod2, mod3, mod4, mod5) %>% plot


# 4.calculates the mean sq. error of each model ####
compare_performance(mod1, mod2, mod3, mod4, mod5)

# 5.selects the best model you tried
# Mod 5 is the best model 


# 6.adds predictions based on new hypothetical values for the independent variables used in your model #### 
df_predictions <- add_predictions(df, mod5)


# 7.plots these predictions alongside the real data ####
df_predictions %>% 
  ggplot(aes(x = growth_rate, y = pred))+
  geom_point()+
  theme_bw()




# Upload responses to the following as a numbered plaintext document to Canvas:
# 1. Are any of your predicted response values from your best model scientifically meaningless? Explain.
      # a lot of the pairwise comparisons in mod5 are insignificant according to a p value of 0.05
      # there were four significant interactions and several near-significant interactions. 

# 2. In your plots, did you find any non-linear relationships? Do a bit of research 
#  online and give a link to at least one resource explaining how to deal with modeling non-linear relationships in R.
    # My prediction plot looks like it's exponential
    # https://www.geeksforgeeks.org/non-linear-regression-in-r/


# 3. Write the code you would use to model the data found in “/Data/non_linear_relationship.csv” #  with a linear model (there are a few ways of doing this)
nonlinear <- read_csv("./non_linear_relationship.csv")

# Transform data
transformed_nonlinear <- nonlinear %>%
  filter(rowSums(. != 0) == ncol(.))
transformed_nonlinear <- na.omit(transformed_nonlinear)
nonlinear_model <- lm(data = transformed_nonlinear, formula = response ~ predictor) %>% 
  ggplot(aes(x = predictor, y = response))+
  geom_point()
print(nonlinear_model)
