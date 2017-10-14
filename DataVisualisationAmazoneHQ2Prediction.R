#Amazone HeadQuarter
library(rvest) 
library(tidyverse)
library(stringr)
library(ggmap)
#library required for the task
amz_cities <- read_html("https://www.cbsnews.com/news/amazons-hq2-cities-second-headquarters-these-cities-are-contenders/")
df.amz_cities <- amz_cities %>%#
  html_nodes("table") %>%      #
  .[[1]] %>%                   # 
  html_table()                 #
#inspect
colnames(df.amz_cities)
colnames(df.amz_cities) <- c("Metro_Area", "State", "population", "prcnt_of_Graduate")
df.amz_cities %>% head()
#it created inconsistant column name
#so need to remove one row of name
df.amz_cities <- df.amz_cities %>% filter(row_number() != 1)
#problem is the population and percentage is in charecter format and we need it in numeric format
#so i have to change it into numeric format using mutate function of dplyr package
df.amz_cities <- mutate(df.amz_cities, population = parse_number(population))
df.amz_cities <- mutate(df.amz_cities, prcnt_of_Graduate = as.numeric(prcnt_of_Graduate))
#creating a city column from metro area column ignoring the charecter after -(hyphen)
df.amz_cities <- df.amz_cities %>% mutate(city = str_extract(Metro_Area, "^[^-]*"))
#geocode to find longitude and latitude of city
data.geo <- geocode(df.amz_cities$city)
head(data.geo, 3)
#adding data.geo column with df.amz_cities using cbind
df.amz_cities <- cbind(df.amz_cities, data.geo)
head(df.amz_cities,3)
#changing the name lon to long and lat is okay.
df.amz_cities <- rename(df.amz_cities, long = lon)
#reordering the columns names using select cmd
df.amz_cities <- select(df.amz_cities, city, State, Metro_Area, long, lat, population, prcnt_of_Graduate)
#ploting the city on USA map using map_data function
map.states <- map_data("state")
#now the plots
#data visualzation with ggplot2
#checking everything is okay or not
ggplot()+geom_polygon(data = map.states, aes(x = long, y = lat, group = group))+geom_point(data = df.amz_cities, aes(x = long, y = lat, size = population, color = prcnt_of_Graduate))
#making the plot more readeble and formatted
#data visualisation with ggplot2
library(Scale)
ggplot() +
  geom_polygon(data = map.states, aes(x = long, y = lat, group = group)) +
  geom_point(data = df.amz_cities, aes(x = long, y = lat, size = population, color = prcnt_of_Graduate*.01), alpha = .5) +
  geom_point(data = df.amz_cities, aes(x = long, y = lat, size = population, color = prcnt_of_Graduate*.01), shape = 1) +
  coord_map(projection = "albers", lat0 = 30, lat1 = 40, xlim = c(-121,-73), ylim = c(25,51)) +
  scale_color_gradient2(low = "red", mid = "yellow", high = "green", midpoint = .41, labels = scales::percent_format()) +
  scale_size_continuous(range = c(.9, 11),  breaks = c(2000000, 10000000, 20000000),labels = scales::comma_format()) +
  guides(color = guide_legend(reverse = T, override.aes = list(alpha = 1, size = 4) )) +
  labs(color = "Bachelor's Degree\nPercent"
       ,size = "Total Population\n(metro area)"
       ,title = "Possible cities for new Amazon Headquarters"
       ,subtitle = "Based on population & percent of people with college degrees") +
  theme(text = element_text(colour = "#444444", family = "Gill Sans")
        ,panel.background = element_blank()
        ,axis.title = element_blank()
        ,axis.ticks = element_blank()
        ,axis.text = element_blank()
        ,plot.title = element_text(size = 28)
        ,plot.subtitle = element_text(size = 12)
        ,legend.key = element_rect(fill = "white")
  ) 
