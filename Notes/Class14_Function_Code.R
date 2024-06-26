##### Class 14 Function code #####
# String detect example####
x <- "January"

str_detect(x,"Jan")
str_detect(x,"[J,j]anu") # checks for upper and lowercase

#### Actual function code ####


read_trap_data <- 
function(path,sheet,range1,range2){
  trap_days <- read_xlsx(path,sheet = sheet, range = range1,col_names = FALSE)

x <- 
  read_xlsx(path,sheet = sheet, range = range2) %>% 
  clean_names() %>% 
  mutate(across(-species,as.numeric)) %>% 
  pivot_longer(-species,
               names_to = "month",
               values_to = "obs_count") %>% 
  mutate(site = sheet,
         month = str_to_sentence(month),
         species = str_to_sentence(species)) %>% 
  mutate(month = case_when(str_detect(month, "[J,j]an") ~ "January",
                           str_detect(month, "[F,f]eb") ~ "February",
                           str_detect(month, "[M,m]ar") ~ "March",
                           str_detect(month, "[A,a]pr") ~ "April",
                           str_detect(month, "[M,m]ay") ~ "May",
                           str_detect(month, "[J,j]un") ~ "June",
                           str_detect(month, "[J,j]ul") ~ "July",
                           str_detect(month, "[A,a]ug") ~ "August",
                           str_detect(month, "[S,s]ep") ~ "September",
                           str_detect(month, "[O,o]ct") ~ "October",
                           str_detect(month, "[N,n]ov") ~ "November",
                           str_detect(month, "[D,d]ec") ~ "December",
                           TRUE ~ month))

x <- 
  x %>% 
  full_join(data.frame(month = x$month %>% unique,
                       trap_days = trap_days[1,] %>% as.numeric))
return(x)
}

