#005_plots.R


############
# initialize
############
rm(list=ls())
require(tidyverse)
require(lubridate)   # ymd requires
require(jimPackage)
#################
# Retrieve normalized, data f009 - present (local)
#################
result <- readr::read_csv("./data/combine_labs_norm.csv")
what_is_it(result)
glimpse(result)
#################
# Begin plots
#################

#################################
# Simple:   Fasting GLU over time
#################################

z <- result %>% filter(Test_Name== "GLU")

g <- ggplot(z, aes(x=Date,y=Test_Result)) +
	geom_point() +
    scale_x_date(date_labels = "%Y") +
    geom_hline(yintercept = 100, color="red") +
    labs (title = "Fasting Glucose",
          subtitle = "2008 - 2018") +
	geom_vline(data = tibble(    # adding layer!, own data
		x= ymd(c("2012-01-01","2016-05-01"))
		),
		mapping = aes(xintercept = as.numeric(x)),
		color = "blue",
		linetype= 2)   # dotted
            
g
summary(g)
###################################
#   Stop here
###################################

g <-  ggplot(result, aes(x=Date, y=Test_Result)) +
    facet_wrap(~Test_Name, nrows=5)

 g + geom_point()

####################
g <-filter(result, Test_Name == "eGFR") %>% 
    ggplot(aes(x=Date, y=Test_Result))
g + geom_point()

g <-filter(result, Test_Name == "Trig") %>% 
    ggplot(aes(x=Date, y=Test_Result))
g + geom_point()

g <-filter(result, Test_Name == "Ur_Oxalate24") %>% 
    ggplot(aes(x=Date, y=Test_Result))
g + geom_point()

g <-filter(result, Test_Name == "GLU") %>% 
    ggplot(aes(x=Date, y=Test_Result))
g + geom_point()

########################
#  WANT this!
#######################

# look at this
# https://stackoverflow.com/questions/41231903/ggplot2-how-to-add-text-to-multiple-vertical-lines-geom-vlines-on-a-time-x-ax?noredirect=1&lq=1

tmp <- data.frame(x=rep(seq(as.Date(0, origin="1970-01-01"),
							length=36, by="1 month"), 2),
				  y=rnorm(72),
				  category=gl(2,36))
p <- ggplot(tmp, aes(x, y, colour=category)) +
	#layer(geom="line") +
	geom_vline(aes(xintercept=as.POSIXct(
		as.Date(c("2016-12-01","2017-02-01")))   ),
			   linetype=4, colour="black")
print(p)
# as.POSIXct(as.Date(c("2016-12-01","2017-02-01")))
