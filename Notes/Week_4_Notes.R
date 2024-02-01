###########################
###### WEEK 4 NOTES #######
###########################

### Tuesday January 30 and Thursday February 1 ###

### Package of the week ####
library(leaflet)
# Lets you create interactive maps
# R studio has a whole help website that teaches you how to use it 


### Tuesday January 30 ####
library(tidyverse)
library(palmerpenguins)

# Convert the following code expressions into "pipe format" to make them more readable

unique(stringr::str_to_title(iris$Species))
iris$Species %>% # The way it's written here is fine, but you could also pluck just to get a single column
  stringr::str_to_title() %>% #stringr is for working with character strings. String to title capitalizes every word
  unique() # this just gives us the unique ones it founds 

iris %>% 
  pluck("Species") %>% 
  stringr::str_to_title() %>% 
  unique()

max(round(iris$Sepal.Length),0)
iris %>% 
  pluck("Species")

mean(abs(rnorm(100,0,5)))
rnorm(100,0,5) %>% 
  abs() %>% 
  mean()

median(round(seq(1,100,0.01),1))
seq(1,100,0.01) %>% 
  round(1) %>% 
  median()

# Intro to plotting
library(palmerpenguins)
x <- 
  penguins %>% 
  mutate(fatstatus = case_when(body_mass_g > 5000 ~ "fattie",
                               body_mass_g <= 5000 ~ "skinny")) # case when only works inside of mutate


x %>%
  filter(!is.na(sex)) %>% 
  ggplot(mapping = aes(x=body_mass_g,
                       y=bill_length_mm,
                       color = fatstatus,
                       shape = fatstatus)) + 
  geom_point() +
  geom_smooth() + 
  scale_color_manual(values=c("turquoise","pink")) +
  #scale_color_viridis_d(option = 'turbo') + 
  theme_light()

# ggplot really wants a dataframe. it also wants to know how to map the variables onto the plot 'mapping'
# + starts adding layers to the plot 

# In the global environment (namespace), it understands x is a dataframe. If you click on global
# environment, it will show you all of the namespaces that R currently knows from all of the packages you have 

# what arguments does ggplot want? 
## ggplot wants a dataframe
ggplot(penguins) # It gave you a plot. But you also need to tell it the aesthetics and the mapping
# We need to map our variables (the columns) to various things, such as axes, color, size, shape, etc 
names(penguins) #just showing the column names 

#geom col for a bar chart
ggplot(penguins, mapping = aes(x = flipper_length_mm,
                               y = body_mass_g, fill = species)) +
  geom_col() # this is probably what you want if you want a bar chart in ggplot
# This is a lil weird. What penguin is 80,000g? 
# This says it used position stat
# Add a fill aesthetic to see what the fuck it did 
# So it summed up all of the masses of the penguins with a given flipper length 

ggplot(penguins, mapping = aes(x = flipper_length_mm,
                               y = body_mass_g, fill = species)) +
  geom_col(position='dodge')

#geom line
ggplot(penguins, mapping = aes(x = flipper_length_mm,
                               y = body_mass_g,color=species)) + # these are global aesthetics
  geom_line(aes(group=species)) # if you don't specify an aesthetic for your lower geoms, they will inherit the global aesthetics


ggplot(penguins, mapping = aes(x = flipper_length_mm,
                               y = body_mass_g,color=species)) +
  geom_path(aes(group=species)) +
  stat_ellipse()+
  geom_point(color='magenta') # it has a certain je ne sais quoi

ggplot(penguins, mapping = aes(x = flipper_length_mm,
                               y = body_mass_g,color=species)) +
  geom_path(aes(group=species)) +
  stat_ellipse()+
  geom_point(aes(color=sex))+
  geom_hex()+
  geom_bin_2d()+
  geom_polygon() # the polygons are covering up the hexagons b/c ggplot does this by layers. one layer covers up another

ggplot(penguins, mapping = aes(x = flipper_length_mm,
                               y = body_mass_g,color=species)) +
  geom_path(aes(group=species)) +
  stat_ellipse()+
  geom_point(aes(color=sex))+
  geom_polygon()+
  geom_hex()+
  geom_bin_2d()+
  geom_boxplot()+ # grouped them by species b/c color=species is mapped globally
  geom_hline(yintercept=4500,linewidth=15,color='magenta',
             linetype='1121',alpha=0.25)

# alpha is transparency. It goes from 0-1, where 0 is totally transparent and 1 is opaque. They do overlap in transparency

# lets add another global map
ggplot(penguins, mapping = aes(x = flipper_length_mm,
                               y = body_mass_g,color=species,alpha=bill_depth_mm)) +
  geom_path(aes(group=species)) +
  stat_ellipse()+
  geom_point(aes(color=sex))+
  geom_polygon()+
  geom_hex()+
  geom_bin_2d()+
  geom_boxplot()+ # grouped them by species b/c color=species is mapped globally
  geom_hline(yintercept=4500,linewidth=15,color='magenta',
             linetype='1121',alpha=0.25)+
  geom_point(color="yellow",aes(alpha=bill_depth_mm)) + # aes is for mapping a specific column 
  theme(axis.title = element_text(face = "italic",size=12,angle=30),
        legend.background = element_rect(fill='hotpink',color='blue',linewidth=5))


# there are many different built in themes, and you can also do custom theme
# essentially what's inside of aes is saying that alpha shall be based on column name 
library(ggimage)


##### Thursday 1 February 2024 ####

# Warm up 
# make an interesting plot of the penguin data 

## Here's my plot
str(penguins)
ggplot(penguins, mapping = aes(x = bill_depth_mm,
                               y = bill_length_mm))+
  geom_point(aes(color=species))+
  geom_smooth(method = "loess", se = TRUE, color = "hotpink")+
  labs(y = 'Bill Length (mm)', x = 'Bill Depth (mm)')

## This code does the exact same thing, but it's a little easier to read and code
penguins %>% 
  ggplot(aes(x = bill_depth_mm,
             y = bill_length_mm))+
  geom_point(aes(color=species))+
  geom_smooth(method = "loess", se = TRUE, color = "hotpink")+
  labs(y = 'Bill Length (mm)', x = 'Bill Depth (mm)')

  
penguins %>% 
  ggplot(aes(x = factor(year), # this splits the plot up to give you three box plots, one per year
             y = body_mass_g)) + 
  geom_boxplot()+
  geom_point() # all of the points are overlapping and hiding the data

penguins %>% 
  ggplot(aes(x = factor(year),
             y = body_mass_g)) + 
  geom_boxplot()+
  geom_jitter(height=0,width=0.1,alpha=0.2) # avoids overplotting issue by introducing random variation 
# Boxplots tend to hide the data, so this shows where the data actually lies 
# Boxplots really want one numeric and one categorical variable. Not two cat or two num


penguins %>% 
  ggplot(aes(x=body_mass_g, fill=species))+
  geom_density(alpha=.25)
# This created a distribution. Always a good idea to look at the distribution of the variables of interest 
## Dr. Z's rules for plottiing
# Rule 1: Don't hide your data
# Rule 2: Have a goal for your plot. What are you trying to discover from your data that plotting would help with? 


df <- read_delim("./Data/DatasaurusDozen.tsv")
df %>% 
  group_by(dataset) %>% # Why would you want to group a dataframe by some data? Bc you want to do groupby summarize
  summarize(meanx=mean(x),
            sdx=sd(x),
            minx=min(x),
            medianx=mean(x)) # The means and sd are exactly the same. The median and min are roughtly the same 
df %>% 
  ggplot(aes(x=x,fill=dataset))+
  geom_density(alpha=0.3) 
# Even though the summary statistics are exactly the same, the distributions are wildly different

df %>% 
  ggplot(aes(x=x,y=y))+
  geom_point()+
  facet_wrap(~dataset) 
# facet syntax: ~Columnname. Creates different subplots for each column
#See, a t-test would tell you there is no different in these means


library(GGally)
ggpairs(penguins) # Look at all of the variables in your entire dataset. Works best when you have less than ten variables 
# Takes every possible combo of all of our columns and plots them. 
# It also gives you correlations and an automatic significance value for those correlations 

penguins %>% 
  ggplot(aes(x=body_mass_g,
             y=bill_depth_mm))+
  geom_point(aes(color=sex),shape=18,size=4,alpha=0.75)+
  facet_wrap(~species,)+
  scale_color_manual(values=c("rosybrown1","steelblue4"))

# If you set the scale to free, it's harder to see the differences between the datasets. This has hidden the data a little bit
# Rule X: Make it easy for people to see the story in your figure 


# 