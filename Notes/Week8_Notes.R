############################
####### WEEK 8 NOTES #######
############################
library(tidyverse)
library(readxl)
library(measurements)

##### Class 15: Tuesday February 27 ####

# DATA ####
path <- "./Data/human_heights.xlsx"
dat <- read_xlsx(path)

# CLEAN ####
# female/male is a single variable spread across multiple cols. bad
dat <- 
  dat %>% 
  pivot_longer(everything(),
               names_to = "sex",
               values_to = "height") %>% 
  separate(height, into = c("feet","inches"),convert = TRUE) %>% 
  mutate(inches = (feet*12) + inches) %>% 
  mutate(cm=conv_unit(inches, from='in',to='cm'))

# Distribution plot
# Geom_density will create a distribution plot if you give it an x or a y
dat %>% 
  ggplot(aes(x=cm,fill=sex)) +
  geom_density(alpha=.5)

# #Is there a height difference between males and females? Design an experiment 
# that would answer this question.
  # Measure height. Experimental design: you need to control for demographics
  # At UVU is there a height difference between 21 year old males and females
    # Experiments require a specific question
  # This experiment has an n=33
  # Instead of measuring every single 21 year old in the true population, we 
  # sample from the population 
  # So, it looks like it's different, but how do we tell if the means are actually different?
      # Hypothesis testing
  # t-tests help us falsify assertions since we don't actually prove anything in science

?t.test()
# T-tests want an x and y
# The help file says that this test wants a formula. This is where I started voice recording
x ~ y 
# LHS is a numeric variable
# RHS can be either 1 or a factor with 2 levels 
# The thing we measured that we want to know something about is always going to be 
  # on the LHS of the formula 
# The RHS will be sex 
t.test(dat$cm ~ factor(dat$sex))

# The only thing a t test is good for is comparing the means between exactly two groups
# does account for sample size, stdev, etc
# p-value: assuming the null hypothesis is true, the p-value gives you the liklihood 
  # that you would get your results by chance
# P- value can be thought of as the surprise value. The smaller this number, the more
  # shocked you would be to see these values if there really is no difference.
  # the p-value is a measuer of how shocked you ought to be if you see these measurements
  # from completely overlapping bell curves. The smaller it is, the more shocked
# Type 1 error: 5/100 times you would get this result even if there is no difference
# Smaller is better, there is no magic cut off b/c the significance of a p-value
  # really is arbitrary and depends on the field


# Generalized linear model ####
mod <- glm(data = dat,
    formula = cm ~ sex) # can you predict height using sex
#LHS: Dependent variable
#RHS: Independent variables
summary(mod)
# Pr(>|t|)  is the probability that our results are greater than the absolute t value.
  # In other words, it's the p value
# If you had a straight line, y is the dependent var (y=mx+b), b is the intercept
# Estimate of sexmale is basically equal to the slope (m)
# The intercept estimate is the average height 
# Being male adds on average 7.466 cm to your height
# The summary gave us the statistical representation of our graph 
# Most important pieces from this output is the p value and the estimate 

# Let's practice with mpg
mpg
names(mpg)
# measured mpg on highway and in city. this could be affected by class, manufacturer, etc
# But mpg doesn't affect manufacturer 
# Displacement probably affects city mpg 

mpg %>% 
  ggplot(aes(x = displ,
             y = cty))+
  geom_point()+
 geom_smooth(method = 'glm') # add trend line

glm(data = mpg,
    formula = cty ~ displ) %>% 
  summary()
# this is the statistical version of the above plot 
# There are other variables in the dataset that could make your model less wrong, 
  # such as cyl, manufacturer, etc
# models will always be wrong, but that doesn't mean they aren't useful, e.g. for prediction
# summary() essentially gives us the equation of the line 

mod$coefficients # nice 
mod$R

# Package time

#install.packages("easystats")
library(easystats)
report(mod) # I'm going to cum rn 
performance(mod) 

#rmse = root mean squared error. tells us on average how far away our actual data points
  # are from our line of best fit. the model is that wrong on average. you want this 
  # number to be smaller also but not so small b/c that indicates that you over-fit your model

performance::check_model(mod) # is your model valid or not 

data.frame(A = rnorm(500,mean=0, sd = 1),# pulls random numbers from a normal distribution 
            B = rnorm(500, mean=5, sd =1)) %>% 
  pivot_longer(everything()) %>% 
  ggplot(aes(x = value, fill = name))+
  geom_density() # the more you increase your amount of random numbers, the better your model is. 
        # in other words, the more you sample, the better your representation of the underlying
        # distribution

