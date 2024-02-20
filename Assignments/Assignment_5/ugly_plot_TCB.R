##### Ugly Plot Contest #####

library(tidyverse)
library(readxl)
library(skimr)
library(janitor)
library(stringr)
library(jpeg)
library(grid)
library(ggimage)
library(patchwork)
library(gganimate)
library(showtext)
library(sysfonts)
library(extrafont)

font_import(paths = "/Users/tessablack/Desktop/Data_Course_BLACK/Assignments/Assignment_5/LDFComicSans.ttf")
loadfonts()


original_titanic_deaths <- read_csv("./Assignments/Assignment_5/titanic.csv")

#First: change ticket price from pound/shilling/pence to pound
# Second: adjust ticket price in pounds for inflation as of 2023 (using bank of england 
# inflation calculator, 1 pound in 1918 = 47.02 pounds in 2023)
# Third: change pounds to USD using exchange rate on 6/16/2023, where 1 pound = 1.2823 USD
# Fourth: remove the individual pnd/shl/pnc columns
# Fifth: add a column called "wreck_year"

original_titanic_deaths <- original_titanic_deaths %>% 
  mutate(ticket_price_pnds=pnd+shl/20+pnc/240) %>% 
  mutate(inflated_ticket_price_pnd=ticket_price_pnds*47.02) %>% 
  mutate(ticket_price_USD=inflated_ticket_price_pnd*1.2823) %>% 
  mutate(wreck_year=as.numeric(1918)) %>% 
  select(-pnd,-shl,-pnc,-ticket_price_pnds,-inflated_ticket_price_pnd)
str(original_titanic_deaths)


# Import oceangate data ####
oceangate <- read_xlsx("./Assignments/Assignment_5/titan_submersible_deaths.xlsx")
str(oceangate)
View(oceangate)


#Fulljoin
total_titanic_deaths <- full_join(original_titanic_deaths,oceangate)
View(total_titanic_deaths)
#write_csv(total_titanic_deaths,file="./Assignments/Assignment_5/titanic_deaths_total.csv")

# Total deaths by year bar chart #####
total_deaths_by_year <- total_titanic_deaths %>%
  filter(survived == "FALSE") %>%
  group_by(wreck_year) %>%
  summarise(total_deaths = n())

#write_csv(total_deaths_by_year,file = "./Assignments/Assignment_5/deaths_by_year.csv")

background4 <- readJPEG("./Assignments/Assignment_5/background4.jpeg")

p1 <- total_deaths_by_year %>% 
  ggplot(aes(x=wreck_year,
         y=total_deaths)) +
  ggplot2::annotation_custom(rasterGrob(background4, 
                                        width = unit(1,"npc"),
                                        height = unit(1,"npc")), 
                             -Inf, Inf, -Inf, Inf)+
  geom_col(width=19,color="magenta", fill="magenta") +
  labs(x = "year", y = "deaths",title = "total titanic deaths by year BaR ChArT")+
  scale_x_continuous(breaks=c(1918,2023))+
  scale_y_continuous(breaks = c(0,150000),limits=c(0,150000),
                     trans = "sqrt")+
  theme(axis.text.x = element_text(angle = 90,hjust=1,vjust=0.5,color="moccasin",family = "LDFComicSans"))+
  theme(axis.text.y = element_text(color = "green1"))+ # I did this on purpose. I know I could have
  # made the text blank, but I think it's funnier (and more evil) to do this
  theme(axis.title.x = element_text(angle = 180, family = "LDFComicSans", color = "yellow"))+
  theme(axis.title.y = element_text(hjust = 0.5,vjust = -102,family = "LDFComicSans", color = "yellow"))+
  theme(title = element_text(family = "LDFComicSans",color = "red"))+
  theme(plot.background = element_rect(fill="green1"))
print(p1)

# Total deaths by year line #####

all_years <- data.frame(wreck_year = 1910:2023)
all_years <- all_years %>%
  left_join(total_deaths_by_year, by = "wreck_year") %>%
  replace_na(list(total_deaths = 0))

background2 <- readJPEG("./Assignments/Assignment_5/background_2.jpeg")


# Actual plot code
p2 <- all_years %>% 
  ggplot(aes(x = wreck_year, y = total_deaths)) +
  ggplot2::annotation_custom(rasterGrob(background2, 
                                        width = unit(1,"npc"),
                                        height = unit(1,"npc")), 
                             -Inf, Inf, -Inf, Inf)+
  geom_smooth(se = TRUE,color="gray",linewidth=4)+
  geom_hline(aes(yintercept = 0, color = "turquoise"))+
  labs(x = "YEar",y="tota ldeaths",title="titanic deaths by year LiNe gRaPh")+
  theme(axis.ticks.x = element_blank())+
  theme(axis.text.x = element_text(angle=90,hjust=1,vjust=0.5, family = "LDFComicSans", color = "orchid"))+  
  theme(axis.text.y = element_text(angle=289,hjust=1,vjust=0.5, family = "LDFComicSans", color = "orchid"))+
  scale_x_continuous(breaks = c(1918, 1945,1950,1999,2028), limits=c(1918,2030))+
  theme(plot.background = element_rect(fill="green1"))+
  theme(axis.title.x = element_text(hjust = 1, angle = 45, family = "LDFComicSans", color = "chocolate1"))+
  theme(axis.title.y = element_text(color = "yellowgreen", family = "LDFComicSans"))+
  theme(title = element_text(color = "red",family = "LDFComicSans"))+
  theme(legend.background = element_rect(fill = "olivedrab1"))
print(p2)

# Plot average titanic deaths per year
background <- readJPEG("./Assignments/Assignment_5/background_.jpeg")

p3 <- total_deaths_by_year %>% 
  ggplot(aes(x = wreck_year, y = total_deaths)) +
  ggplot2::annotation_custom(rasterGrob(background, 
                                        width = unit(1,"npc"),
                                        height = unit(1,"npc")), 
                             -Inf, Inf, -Inf, Inf)+
  geom_hline(aes(yintercept = 14.29524), color = "yellow", linewidth=0.5) +
  labs(x = "year", y = "average deaths", 
       title = "average slayings by Ms. Titanic per year") +  
  theme(plot.background = element_rect(fill="green1"))+
  theme(title = element_text(family = "LDFComicSans",color="cornflowerblue"))+
  scale_x_continuous(breaks = c(1918, 2023), limits=c(1918,2023))+
  scale_y_continuous(breaks = c(0,1501),limits=c(0,1501))+
  theme(axis.text.x = element_text(angle=90,hjust=1,vjust=0.5,size=6,family = "LDFComicSans"))+
  theme(axis.title.y = element_text(family = "LDFComicSans", color = "deepskyblue4"))+
  theme(axis.title.x = element_text(family = "LDFComicSans",color = "deeppink4"))+
  theme(axis.text.x = element_text(family = "LDFComicSans", color = "wheat1"))+
  theme(axis.text.y = element_text(family = "LDFComicSans", color = "slateblue1"))
print(p3)

#ggsave("./Assignments/Assignment_5/average_titanic_deaths_by_year_plot.png", plot=avg_deaths_plot,dpi=300)

three_bitchin_plots <- (p1|p2)/p3
print(three_bitchin_plots)

ggsave("./Assignments/Assignment_5/three_bitchin_plots.png",plot=three_bitchin_plots,dpi=300)
