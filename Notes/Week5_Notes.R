###########################
###### WEEK 5 NOTES #######
###########################

### Class 9: Tuesday February 6 and Class 10 Thursday February 8 ###

library(tidyverse)
library(gapminder)
library(ggimage)
library(gganimate)
library(patchwork)

### Ugly plot contest ####
# axis breaks to fuck up your axes 
# ggalignment
# xkcd

## Class 9: Tuesday 6 Feb ####
# ggcoverage for component analysis 

df <- gapminder

gapminder %>% 
  ggplot(aes(x = lifeExp,
             y = gdpPercap))+
  #geom_line()
  geom_point(aes(color = continent))

# you can save a plot as an object. The object will contain all of the requirements
# to turn that data into the plot image
# you can add things to your plot object
# Plot 1
p <- df %>% 
  ggplot(aes(x = year, y = lifeExp, color = continent))+
  geom_point(aes(size = pop))+
  facet_wrap(~continent)+
  scale_color_viridis_d()

p.A <- df %>% 
  ggplot(aes(x = year, y = lifeExp, color = continent))+
  geom_point(aes(size = pop))+
  #facet_wrap(~continent)+
  scale_color_viridis_d()

p2 <- 
  p.A +
  facet_wrap(~continent)

p/p.A + plot_annotation(title = "Comparing with and without facets")


p.dark <- 
p+
  theme_dark()


# You can make a bunch of plots and stick them together in any order that you want using the patchwork package
p+p.dark
p/p.dark
(p+p.dark)/p.dark 
(p+p.dark)/p.dark + plot_annotation("MAIN_TITLE") # You can annotate plots, add titles, subtitles, etc
(p+p.dark)/p.dark + plot_annotation("MAIN_TITLE")+
  patchwork::plot_layout(guides = 'collect')


p3 <- 
  ggplot(df,
         aes(x=gdpPercap,y=lifeExp,color=continent))+
  geom_point(aes(size=pop))
  #geom_text(aes(label=country))

p3
df$year %>% range
# How do you only label countries you gaf about
df$country %>% unique
mycountries <- c("Venezuela","Rwanda","Nepal","Iraq","Afghanistan","United States")

df <- 
  df %>% 
  mutate(mycountries = case_when(country %in% mycountries ~ country)) # yay it worked

names(df)

p3 <- 
  ggplot(df,
         aes(x=gdpPercap,y=lifeExp,color=continent))+
  geom_point(aes(size=pop))+
  geom_text(aes(label=mycountries))

p3+
  transition_time(time = year)+
  labs(title='Year:{frame_time}')

anim_save("./gapminder_animation.gif")
ggsave("./plot_example.png",dpi = 200,plot=p3) # saves it as a png. After the comma, you can tell it 
# what plot to save, for example, you can tell it to save just p3. You can also tell it width and height
