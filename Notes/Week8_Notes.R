############################
####### WEEK 8 NOTES #######
############################
library(tidyverse)
library(readxl)
library(measurements)
library(easystats)
library(MASS)

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

##### Class 16: Tuesday February 29 ####
# Models are used to simplify the universe so we can use it to predict 

mod1 <- glm(data = mpg, formula = cty ~ displ)
class(mod1)
mod1$coefficients # Coefficients are the influence of displacement. It gave you a negative number, meaning
# as displ goes up, cty goes down
mod1$residuals # the distance each actual datapoint is from the predictor line 
# that the model has mathematically drawn 
mod1$formula %>% as.character()
names(mpg) # we have other things that might help us have a better understanding of cty, such as cyl

mpg$cyl
mod1 <- glm(data = mpg, formula = cty ~ displ) # only knows how to use displ to predict cty
mod2 <- glm(data = mpg, formula = cty ~ displ + cyl) # only knows how to use displ and cyl to predict cty
mod3 <- glm(data = mpg, formula = cty ~ displ * cyl) # Interaction variable

# plot of mod1
mpg %>% 
  ggplot(aes(x=displ,y=cty))+
  geom_smooth(method = 'glm')+
  theme_minimal()

# plot of mod3
# this says that the effect of displ could depend on cyl 
mpg %>% 
  ggplot(aes(x=displ,y=cty, color = factor(cyl)))+
  geom_smooth(method = 'glm')+
  theme_minimal()

# What do we see? The effect of displ for 4 cyl is a sharp decrease. Much less for 6 cyl, and you actually 
# get an increase for 8cyl 
# Which model is best? 

compare_models(mod1,mod2,mod3)
# The effect of displ on cty is different for mod 1 vs mod2 (-2.63 vs. -1.20). Why? 
  # bc cyl is explaining some of that 

compare_performance(mod1,mod2,mod3) %>% plot
# According to this is the best model is mod3. R2 tells you how much of the variation your model explains
# compared to just the mean.
# AIC: smaller is better. you want your model to be as simple as possible. Re-listen 10:10-10:22 
  # bc I missed some of this 

predict(mod1,mpg)
mod1$formula # the only thing it knows is displ. this model can only predict city based on displ

# We trained our model on the mpg dataset, and then we gave it a bunch of displs (1-100)
# and had it predict some cty values based on those displs 
predict(mod1, data.frame(displ = 1:100)) %>% plot
# So this isn't possible lmao b/c it says if you have a displ of 100 then you'll actually make gasoline
# Models are only good for predicting based on what it's trained on. It doesn't know what to do 
  # with cars that have a displ of 50 b/c we didn't train it on those values 
mpg$displ %>% range # so we can only use our model to predict cty for displs between 1.6 and 7.0

mpg$pred <- predict(mod1, mpg)# made a new column for the predictions
mpg$pred2 <- predict(mod2, mpg)
mpg$pred3 <- predict(mod3, mpg)
mpg %>% 
  ggplot(aes(x=cty,y=pred))+
  geom_point()
# This shows the actual cty on the x axis, and pred on the y axis. If the model were perfect, you 
  # would see a straight line (y=mx+b)
# mod1 does better at predicting some values (the lower ones) than others 
mpg %>% 
  ggplot(aes(x=cty,y=pred3))+
  geom_point()

# need to pivot longer b/c we don't have model number as a variable 
mpg %>% 
  pivot_longer(starts_with("pred")) %>% 
  ggplot(aes(x=displ,y=cty,color=factor(cyl)))+
  geom_point()+
  geom_point(aes(y=value),color='black')+
  facet_wrap(~name)
# relisten around 10:35 for what he said about this plot b/c I had to troubleshoot this bs 

# All of our models suck with low displ values, probably b/c we have a limited sample size for that 
names(mpg)
mpg$trans %>% table # lets just do manual vs auto since we have limited sample size for some of these bitches

# add new column indicating whether automatic or not 
mpg <- 
  mpg %>% 
  mutate(auto = grepl("auto",trans)) #grepl does something with logical statements 
# the auto column is just going to say true/false 

mod4 <- glm(data=mpg, formula = cty ~ displ * cyl * auto)
mod5 <- glm(data=mpg, formula = cty ~ displ * cyl * trans * drv * class + year)
formula(mod5)
step <- stepAIC(mod5)


compare_models(mod1,mod2,mod3, mod4) # we got 4 new model terms even though we just added the auto
  # component, b/c we get auto x cyl, and auto x displ, etc 
# There's also a very low difference in explanatory power (R2 and RMSE) between mod3 and mod4. 
  # so we did improve our model a little tiny bit (by like 1%) at the cost of a lot of added complexity
compare_performance(mod1,mod2,mod3, mod4) %>% plot # we see that mod4 might be overcomplicated
  # for not enough of a difference from mod3 
summary(mod4) # it does say that displ, cyl, and autotrue are all significant
  # displ:cyl is very significant. displ:cyl:autoTRUE is also significant
mod_best <- glm(data = mpg, formula = formula(step))

compare_models(mod1,mod2,mod3, mod4, mod_best)
compare_performance(mod1,mod2,mod3, mod4, mod_best) %>% plot


#relisten around 11:03-11:06 where he's talking about different models bc I zoned out 
mod1 <- glm(data = mpg, formula = cty ~ poly(displ,2)) # make it a second order polymnomial 

check_model(mod_best)


