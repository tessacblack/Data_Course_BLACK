############################
####### WEEK 9 NOTES #######
############################
library(tidyverse)
library(easystats)
library(palmerpenguins)
library(caret)
library(broom)
library(modelr)

# Show and tell: PDF tools
library(pdftools)
#pdftools::pdf_combine(p1,p2,p3,output = "~./Desktop/whatever.pdf")

#### Class 17: Tuesday March 5 ####

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


#### Class 18: Thursday March 7 ####
mod1 <- mpg %>% 
  glm(data=.,
      formula=cty~displ+drv)
summary(mod1)
# If you wanted to filter stuff out of your model, summary isn't super useful 
broom::tidy(mod1) # this turns your model output into a dataframe, which allows you 
# to run more analyses and do more things with it like filter for significance, etc 

broom::tidy(mod1) %>% 
  kableExtra::kable() %>% 
  kableExtra::kable_classic(lightable_options='hover') # this lets us create cool outputs
# such as interactive tables, but we don't have the kable packages installed yet :)


# This is a shortcut for what we did when we did predict and then added it as another column
  # it does both of those at the same time and creates a new column that is called 'pred'
add_predictions(mpg,mod1) %>% 
  ggplot(aes(x=pred,y=cty))+
  geom_point()

# this just plots all of the fucking residuals, which tells us how off we are 
add_residuals(mpg,mod1) %>% 
  ggplot(aes(x=resid,y=cty))+
  geom_point() 
# our model does better at predicting cty in the lower range than the higher range
    # this is partially b/c we don't have many bigger cars like big trucks in our dataset, 
    # so it hasn't been trained on those very well 

# the true test of a model is how well does the model do at predicting things it hasn't already seen?
  # this is called cross-validation
  # it's not a good test to see how well your model predicts things it's already seen,
  # since it's basically just memorized the patterns 

# cross-validation
# test your model on new data (and that data has to have actual answers for comparison)
  # how do you get that new dataset? 
  # before you start making your model, you split your data into a training set and a 
  # testing set. So you train the model on part of the data and keep the other part of it 
  # hidden from the model. After training, you give your model the new information


# the y value is your outcome variable
# the p value is the percent that should go into our training
id <- caret::createDataPartition(mpg$cty, p = .8, list = FALSE) 
train <- mpg[id,] # everything that is those row numbers
test <- mpg[-id,] # everything that is not those row numbers

# next, train model on training set
mod2 <- glm(data = train, formula = mod1$formula)

add_predictions(data=test,model = mod2) %>% # you could also write this as add_predictions(test,mod2)
  mutate(error=abs(pred-cty)) %>% #adds a column that calculates error 
  pluck("error") %>% 
  summary()
# on average, our model is ~1.7 gallons off 

add_predictions(mpg,mod1) %>% 
  mutate(error=abs(pred-cty)) %>%
  pluck("error") %>% 
  summary()
# when you trained your model on the full dataset, the average error was 1.6

library(vegan)
iris %>% 
  ggplot(aes(x=Sepal.Length,y=Petal.Length, color = Species))+
  geom_point()+
  stat_ellipse() # this gives you the 95% confidence around the centroid of these clusters

mat <- iris %>% 
  select(-Species) %>% 
  as.matrix()


# permutational ANOVA 
adonis2(mat~iris$Species) # predicts a matrix based on other stuff 
# the difference: so far we've been predicting a vector (numeric, true/false, etc). 
# here, out output variable is the entire matrix of sepal lengths and widths 

mds <- metaMDS(mat)
data.frame(species=iris$Species,
           mds1=mds$points[,1],
           mds2=mds$points[,2]) %>% 
  ggplot(aes(x=mds1,y=mds2,color=species))+
  geom_point()+
  stat_ellipse()

# file-> new file -> R Markdown 
# anything inside of backticks `` is R code that will be read as code. Outside of the bacticks
# is just text or display. 
# You knit that into an html which just exports the stuff 
# It allows you to format reports and output code and show the output
# What would normally show up in your console shows up in the document that it knits
# ctrl + alt + i is the shortcut to add a new code chunk 

# dillinger.io
    # allows you to visually see what your html is going to look like