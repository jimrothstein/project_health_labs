#1000_wt_bp_READ.R
#
#####################
#	WTS 
#		- JUN 2012- MAY 2015, monthly summary, 
#		- 2008 + JAN 2011 - SEP 2017 (misc sources)
#
#
#
#


## ------------------
## begin
rm(list=ls())
library(tidyverse)
library(readr)
library(lubridate)


# ToDo(jr, study readr_example() )
wt <- read_csv("./data_wt_bp/2012_2015_Weight_SUMMARY.csv")

# have 1 data pt per MONTH, pretend wt on the 1st of month

fudge <- " 01, "
wt1 <- 
	wt %>%
	mutate(Date = 
		   	mdy(paste0( Month, fudge, as.character(Year)) ) 
		   ) %>%
	select(Date, "Avg Wt")


wt_2008_2018_misc <- read_csv("./data_wt_bp/2012-2015_Weight_Monthly - 2008-2018 (misc sources).csv", na = c(0,"","NA"))
z <-
	wt_2008_2018_misc %>%
	filter(! (is.na(wt_lb) & is.na(wt_kg))) %>%
	mutate(wt_lb = ifelse(is.na(wt_lb), wt_kg*2.2, wt_lb)) %>%
	mutate(Date = mdy(Date)) %>%
	select(Date,wt_lb) 

plot(z)




## plot
plot(wt1)   # good 

##
g <- 
	wt1 %>% ggplot(aes(Date,y=`Avg Wt`)) + 
		geom_point() +
		#geom_col(fill="darkorange", na.rm =  TRUE)  +
        labs (title = paste0("Rowing -- Daily Watt-hour"), 
              subtitle = "60 = maximum, 40 = typical\n60 = 1 lightbulb for 1 hour",
              caption = "source: my records",
              y = "Watt-hours")  +
		scale_x_date(date_labels = "%b %Y", date_breaks = "1 year ", 
					 limits =  mdy(c("1/1/2012","12/31/2015"))) 
+ ylim(0,200)#+
g
## -------------------------
## import ./data_wt_bp/all_years_...misc.csv
wt <- read_csv("./data_wt_bp/all_years_wt_bp_misc_entries.csv")
wt1 <- wt %>%
	mutate(Date = 
		   	mdy( Date ),
		   wt = `wt(kg)`
	) %>%
	filter(wt > 0) %>%
	select(Date,wt  )
plot(wt1)
#####################

