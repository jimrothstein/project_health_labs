#1000_wt_bp_READ.R
#
#####################
#	Weight
#		- SOURCE1 = JUN 2012- MAY 2015, monthly summary, 
#		- SOURCE2 = JAN 20 - SEP 2017 (misc sources)
#		- WEIGHT1 = cleaned data from SOURCE
#		- WEIGHT2 = cleaned data from SOURCE2
#
#####################

## ------------------
## begin
rm(list=ls())
library(tidyverse)
library(readr)
library(lubridate)

##########
SOURCE1 <- "./data_wt_bp/2012_2015_Weight_SUMMARY.csv"
SOURCE2 <- "./data_wt_bp/2012-2015_Weight_Monthly - 2008-2018 (misc sources).csv"

wt1 <- read_csv(SOURCE1)

# have 1 data pt per MONTH, pretend wt on the 1st of month

fudge <- " 01, "
WEIGHT1 <- 
	wt1 %>%
	mutate(Date = 
		   	mdy(paste0( Month, fudge, as.character(Year)) ),
		    wt_lb = `Avg Wt`
		   ) %>%
	select(Date, "wt_lb")
plot(WEIGHT1)
##################
# now WEIGHT2
##################
# dates to exclude in misc data
begin_date=ymd("2012-06-01")
end_date=ymd("2015-05-31")
wt2 <- read_csv(SOURCE2, na = c(0,"","NA"))
WEIGHT2 <-
	wt2 %>%
	filter(! (is.na(wt_lb) & is.na(wt_kg))) %>%
	mutate(wt_lb = ifelse(is.na(wt_lb), wt_kg*2.2, wt_lb)) %>%
	mutate(Date = mdy(Date)) %>%
	select(Date,wt_lb) %>%
	filter(Date < begin_date | Date > end_date | 
		   	(month(Date) == "12" & year(Date) == "2012") |
		   	(month(Date) == "1" & year(Date) == "2013"))


plot(WEIGHT2)
#####################
## plot again -ggplot
##
#####################
# plot WEIGHT1 - ggplot
#####################
g <- 
	WEIGHT1 %>% ggplot(aes(Date,y=wt_lb)) + 
		geom_point() +
		#geom_col(fill="darkorange", na.rm =  TRUE)  +
        labs (title = paste0("Rowing -- Daily Watt-hour"), 
              subtitle = "60 = maximum, 40 = typical\n60 = 1 lightbulb for 1 hour",
              caption = "source: my records",
              y = "Watt-hours")  +
		scale_x_date(date_labels = "%b %Y", date_breaks = "1 year ", 
					 limits =  mdy(c("1/1/2012","12/31/2015"))) 
g
######################################
# PLOT WEIGHT2
######################################
h <- 
	WEIGHT2 %>% ggplot(aes(Date,y=wt_lb)) + 
		geom_point() +
		#geom_col(fill="darkorange", na.rm =  TRUE)  +
        labs (title = paste0("Rowing -- Daily Watt-hour"), 
              subtitle = "60 = maximum, 40 = typical\n60 = 1 lightbulb for 1 hour",
              caption = "source: my records",
              y = "Watt-hours")  +
		scale_x_date(date_labels = "%b %Y", date_breaks = "1 year ", 
					 limits =  mdy(c("1/1/2008","12/31/2018"))) 
h


###############################
#  COMBINE WEIGHT1 & WEIGHT2, SAVE to disk
###############################
FINAL_WEIGHT <- rbind(WEIGHT1,WEIGHT2)
##
## use data.table
library(data.table)
saveRDS(FINAL_WEIGHT, "./tidy_data/FINAL_WEIGHT.rds")
x <- readRDS("./tidy_data/FINAL_WEIGHT.rds")
identical(x,FINAL_WEIGHT) # TRUE
