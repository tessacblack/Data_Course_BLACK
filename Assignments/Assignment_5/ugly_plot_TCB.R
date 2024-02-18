##### Ugly Plot Contest #####

library(tidyverse)
library(readxl)
library(skimr)
library(janitor)
library(stringr)
library(jpeg)
library(grid)
library(emojifont)
library(ggimage)

original_titanic_deaths <- read_csv("./Assignments/Assignment_5/titanic.csv")
View(titanic_deaths)

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
write_csv(total_titanic_deaths,file="./Assignments/Assignment_5/titanic_deaths_total.csv")

# Total deaths by year bar chart #####
total_deaths_by_year <- total_titanic_deaths %>%
  filter(survived == "FALSE") %>%
  group_by(wreck_year) %>%
  summarise(total_deaths = n())

write_csv(total_deaths_by_year,file = "./Assignments/Assignment_5/deaths_by_year.csv")

background4 <- readJPEG("./Assignments/Assignment_5/background4.jpeg")

bar_chart <- total_deaths_by_year %>% 
  ggplot(aes(x=wreck_year,
         y=total_deaths)) +
  ggplot2::annotation_custom(rasterGrob(background4, 
                                        width = unit(1,"npc"),
                                        height = unit(1,"npc")), 
                             -Inf, Inf, -Inf, Inf)+
  geom_col(width=19,color="pink", fill="green") +
  labs(x = "Year", y = "Total Deaths")+
  scale_x_continuous(breaks=c(1918,2023))+
  scale_y_continuous(breaks = c(0,15000),limits=c(0,15000))+
  theme(axis.text.x = element_text(angle = 90,hjust=1,vjust=0.5))
print(bar_chart)

# Total deaths by year line #####
line <- total_deaths_by_year %>% 
  ggplot(aes(x=wreck_year,
             y=total_deaths)) +
  geom_line()+
  labs(x = "Year", y = "Total Deaths")+
  theme(axis.text.x = element_text(angle = 90,hjust=1,vjust=0.5))
print(line)

all_years <- data.frame(wreck_year = 1910:2023)
all_years <- all_years %>%
  left_join(total_deaths_by_year, by = "wreck_year") %>%
  replace_na(list(total_deaths = 0))

background2 <- readJPEG("./Assignments/Assignment_5/background_2.jpeg")


# Actual plot code
line_plot <- all_years %>% 
  ggplot(aes(x = wreck_year, y = total_deaths)) +
  ggplot2::annotation_custom(rasterGrob(background2, 
                                        width = unit(1,"npc"),
                                        height = unit(1,"npc")), 
                             -Inf, Inf, -Inf, Inf)+
  geom_smooth(se = FALSE,color="gray")+
  labs(x = "YEar",y="tota ldeaths")+
  theme(axis.ticks.x = element_blank())+
  theme(axis.text.x = element_text(angle=90,hjust=1,vjust=0.5))+
  scale_x_continuous(breaks = c(1918, 1945,1950,1999,2028), limits=c(1918,2030))


# Plot average titanic deaths per year
background <- readJPEG("./Assignments/Assignment_5/background_.jpeg")

avg_deaths_plot <- total_deaths_by_year %>% 
  ggplot(aes(x = wreck_year, y = total_deaths)) +
  ggplot2::annotation_custom(rasterGrob(background, 
                                        width = unit(1,"npc"),
                                        height = unit(1,"npc")), 
                             -Inf, Inf, -Inf, Inf)+
  geom_hline(aes(yintercept = 14.29524), color = "yellow") +
  labs(x = "Year", y = "Average Number of Titanic Deaths", 
       title = "Average titanic slayings per Year") +
  scale_x_continuous(breaks = c(1918, 2023), limits=c(1918,2023))+
  scale_y_continuous(breaks = c(0,1501),limits=c(0,1501))+
  theme(axis.text.x = element_text(angle=90,hjust=1,vjust=0.5,size=6))
print(avg_deaths_plot)

ggsave("./Assignments/Assignment_5/average_titanic_deaths_by_year_plot.png", plot=avg_deaths_plot,dpi=300)
