#2000_plot_weight_data.R
###########cut############

rm(list=ls())
library(tidyverse)
library(readr)
library(lubridate)
library(data.table)

FINAL_WEIGHT <- readRDS(file="./tidy_data/FINAL_WEIGHT.rds")
## plot
plot(FINAL_WEIGHT)   #  

h <- 
	FINAL_WEIGHT %>% ggplot(aes(Date,y=wt_lb)) + 
		geom_point() +
		#geom_col(fill="darkorange", na.rm =  TRUE)  +
        labs (title = paste0("Rowing -- Daily Watt-hour"), 
              subtitle = "60 = maximum, 40 = typical\n60 = 1 lightbulb for 1 hour",
              caption = "source: my records",
              y = "Watt-hours")  +
		scale_x_date(date_labels = "%b %Y", date_breaks = "1 year ", 
					 limits =  mdy(c("1/1/2008","12/31/2018"))) 
h
tail(FINAL_WEIGHT
	 )
