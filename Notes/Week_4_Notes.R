###########################
###### WEEK 4 NOTES #######
###########################

### Tuesday January 30 and Thursday February 1 ###

### Tuesday January 30 ####
library(tidyverse)

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




#