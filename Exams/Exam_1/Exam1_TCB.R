library(tidyverse)

# I. Read the cleaned_covid_data.csv file into an R data frame. (20 pts)
df <- read_csv("./data/cleaned_covid_data.csv")



# II. Subset the data set to just show states that begin with “A” and save this as an object called A_states. (20 pts)
A_states <- df[startsWith(df$Province_State, 'A'),]

# 2-15-24 reviewing exam 
A_states_2 <- 
  df %>% 
  filter(grepl("^A",Province_State)) # grep grabs things

# Use the tidyverse suite of packages
# Selecting rows where the state starts with “A” is tricky (you can use the grepl() function or just a vector of those states if you prefer)
# III. Create a plot of that subset showing Deaths over time, with a separate facet for each state. (20 pts)
# Create a scatterplot
# Add loess curves WITHOUT standard error shading
# Keep scales “free” in each facet
ggplot(A_states, aes(x = Last_Update,
                     y = Deaths))+
  geom_point()+ # Creates the scatterplot
  geom_smooth(method = "loess", se = FALSE) +  #adds loess curve without SE shading
  facet_wrap(~Province_State, scales = "free")

# in class review
A_states_2 %>% 
  ggplot(aes(x=Last_Update, y=Deaths)) +
  geom_point()+
  geom_smooth(se=FALSE)+
  facet_wrap(~Province_State,scales='free')


# IV. (Back to the full dataset) Find the “peak” of Case_Fatality_Ratio for each state and save this as a new data frame object called state_max_fatality_rate. (20 pts)

# I’m looking for a new data frame with 2 columns:
#   
#   “Province_State”
# “Maximum_Fatality_Ratio”
# Arrange the new data frame in descending order by Maximum_Fatality_Ratio
# This might take a few steps. Be careful about how you deal with missing values!

state_max_fatality_rate <- df %>%
  group_by(Province_State) %>%
  summarise(Maximum_Fatality_Ratio = max(Case_Fatality_Ratio, na.rm = TRUE)) %>% 
  arrange(desc(Maximum_Fatality_Ratio))

# in class review
state_max_fatality_rate_2 <- 
  df %>% 
  group_by(Province_State) %>% 
  summarize(maximum_fatality_ratio=max(Case_Fatality_Ratio,na.rm=TRUE)) %>% 
  arrange(desc(maximum_fatality_ratio))

#   
#   V. Use that new data frame from task IV to create another plot. (20 pts)
# 
# X-axis is Province_State ##done
# Y-axis is Maximum_Fatality_Ratio ##done
# bar plot ##done
# x-axis arranged in descending order, just like the data frame (make it a factor to accomplish this). ##done
# X-axis labels turned to 90 deg to be readable ## done 
# Even with this partial data set (not current), you should be able to see that (within these dates), different states had very different fatality ratios.
state_max_fatality_rate %>% 
  mutate(Province_State = factor(Province_State, levels = Province_State[order(-Maximum_Fatality_Ratio)])) %>% 
  ggplot(aes(x = Province_State,
             y = Maximum_Fatality_Ratio))+
  geom_col()+
  theme(axis.text.x = element_text(angle = 90))
  
# In class review
# To get things to stay in the same order in your plot, you want to turn things into a factor
state_max_fatality_rate_2 %>% 
  mutate(Province_State=factor(Province_State,levels=state_max_fatality_rate_2$Province_State)) %>%  
  ggplot(aes(x=Province_State,y=maximum_fatality_ratio))+
  geom_col()+
  theme(axis.text.x = element_text(angle = 90,hjust=1,vjust=0.5))


# 
# VI. (BONUS 10 pts) Using the FULL data set, plot cumulative deaths for the entire US over time
# 
# You’ll need to read ahead a bit and use the dplyr package functions group_by() and summarize() to accomplish this.
us_cumulative_deaths <- df %>%
    group_by(Last_Update) %>%
    summarize(Cumulative_Deaths = sum(Deaths, na.rm = TRUE)) %>%
    arrange(Last_Update)
  
ggplot(us_cumulative_deaths, aes(x = Last_Update, y = Cumulative_Deaths)) +
    geom_line() +
    labs(x = "Date", y = "Cumulative_Deaths")


df %>% 
  group_by(Last_Update) %>% 
  summarize(total_deaths=sum(Deaths)) %>% 
  ggplot(aes(x=Last_Update,y=total_deaths))+
  geom_point()
