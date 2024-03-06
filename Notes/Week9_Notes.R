############################
####### WEEK 9 NOTES #######
############################
library(tidyverse)
library(easystats)
library(palmerpenguins)
library(broom)

#### Tuesday March 5 ####

# Warm up: does body_mass_g vary significanctly between penguin species? 
names(penguins)
mod1 <- glm(data=penguins, formula = body_mass_g ~ species)
summary(mod1)
# Compares the other two species to Adelie b/c Adelie starts with A (ie, Adelie is the intercept)
# what if we want to specifically compare Gentoo and Chinstrap? We have to set one of them as 
# the intercept by making it a factor
# So far, all of our models have had numeric continuous outcome variables 
# What if our models could do true/false, like when predicting if someone will have a 
# disease or not 

# Let's try to predict whether a penguin is gentoo or not based on size
# To do this type of classifier test, we need to make a true/false column 
# (Started audio recording here @ 10:11)


# Mod 2 says: the gentoo column is the outcome. predict that true case based on bill depth...
# by default, the glm uses a normal distribution. We don't want it to do that 
        # family = 'guassian' is the default 
# two things to remember for logistic regression: outcome needs to be true/false and 
  # family needs to be binomial 
mod2 <- penguins %>% 
  mutate(gentoo = case_when(species == "Gentoo" ~ TRUE,
                            TRUE ~ FALSE)) %>% 
  glm(data=.,   # the . is a shortcut that basically means "what I just piped" 
      formula = gentoo ~ bill_depth_mm + body_mass_g + flipper_length_mm + bill_length_mm,
      family = 'binomial') # logistic regression
# it's angy b/c it's a bad model but we're ignoring that for the sake of learning 
summary(mod2) # nothing significant
predict(mod2, penguins) # it didn't give us a true false, the bastard
# what it actually did is convert everything into a logistic curve (S curve) 

predict(mod2, penguins, type='response') # thing number 3 to remember about logistic regression
# The first time we did predict, it spit out log odds
# Regardless, it's scaled in a way that we can't really interpret. So you have to tell it to 
# scale the output based on the response variable
penguins$pred <- predict(mod2, penguins, type='response') # same as above, just adding it to the df 


# Plot actual body mass on the x axis, and the model's prediction of true/false on the y axis
  # The overlap comes from the other variables. It's able to distinguish gentoo from other penguins
penguins %>% 
  ggplot(aes(x=body_mass_g, y = pred, color = species))+
  geom_point()

# What if we want to compare how well the pred did compared to the actual daat
preds <- penguins %>% 
  mutate(outcome = case_when(pred<0.01 ~ "not_gentoo",
                             pred >0.75 ~ "gentoo")) %>% 
  select(species, outcome) %>% 
  mutate(correct = case_when(species == "Gentoo" & outcome == "gentoo"~TRUE,
                             species != "Gentoo" & outcome == "not_gentoo" ~ TRUE,
# the above line says when species is not gentoo and outcome is not gentoo, also put true 
                             TRUE ~ FALSE))
# the model did really good, but how can we quantify this
# Count how many times the model matched reality and then divide by the number of rows 

preds %>% 
  pluck("correct") %>% 
  sum() / nrow(preds)
# model is 99.4% accurate. slay
# the more rows of data you can train your model on, the better it is 

dat <- read_csv("./Data/GradSchool_Admissions.csv")
str(dat)
mod3 <- glm(data=dat,
            formula = as.logical(admit)~ (gre+gpa)*rank,
            family = binomial)
summary(mod3)
dat$pred <- predict(mod3, dat, type = 'response')

dat %>% 
  ggplot(aes(x=gre,y=pred,color=factor(rank)))+
geom_point(alpha=.25)+
  geom_smooth()+
  theme_minimal()

dat %>% 
  ggplot(aes(x=factor(rank),y=pred,color=factor(rank)))+
  geom_jitter(alpha=.25)+
  geom_boxplot()+
  theme_minimal() # if we're just looking at rank 
# b/c rank is a factor, you can't do geompoint

# idk what this was about, this was something to do with decision trees 
library(ranger)
library(vip)
rf <- ranger(data=dat,
             formaul = admit ~ gpa + gre + rank, importance = "permutation")
rf
vip(rf)
summary(rf)
# these tests don't give you coefficients, so this can be a bit of a black box
