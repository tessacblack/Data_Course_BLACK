######################
#### Assignment 9 ####
######################
library(tidyverse)
library(caret)
library(broom)
library(modelr)
library(easystats)
library(janitor)
library(skimr)
library(GGally)

df <- read_csv("./GradSchool_Admissions.csv")
str(df)
df <- df %>% 
  mutate(admit = case_when (admit == 1 ~ TRUE,
                            TRUE ~ FALSE))

# Effect of rank on admit
mod1 <- glm(data = df, formula = admit ~ rank, family = 'binomial')
summary(mod1)
# Effect of GPA on admit
mod2 <- glm(data = df, formula = admit ~ gpa, family = 'binomial')

# Effect of GRE on admit
mod3 <- glm(data = df, formula = admit ~ gre, family = 'binomial')

# Effect the interaction between GPA and GRE on admit
mod4 <- glm(data = df, formula = admit ~ gpa * gre, family = 'binomial')

# Full model looking at the interactions of all of these 
full_mod <- glm(data = df, formula = admit ~ gpa * gre * rank, family = 'binomial')

# Compare models 
compare_models(mod1, mod2, mod3, mod4, full_mod)

# Compare performance
compare_performance(mod1, mod2, mod3, mod4, full_mod) %>% plot
  # Smallest AIC is full_mod, smallest RMSE is full_mod

step <- MASS::stepAIC(full_mod, trace = 0)
step$formula

mod5 <- glm(data = df, formula = admit ~ gpa + gre + rank + gpa:gre, family = 'binomial')

# Compare performance again
compare_performance(mod1, mod2, mod3, mod4, full_mod, mod5, rank = TRUE) %>% plot
  # mod 5 is the best 

# Mod 5 predictions
df$mod5pred <- predict(mod5, df, type = 'response')
df %>% 
  ggplot(aes(x=gpa, y = mod5pred))+
  geom_point(alpha = 0.25)+
  geom_smooth()+
  theme_minimal()
