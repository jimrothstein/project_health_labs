## Ur_Uric ONLY!! (to play)
## labs_results_v1.R for main code

# Medical - Historical LAB Results
# https://docs.google.com/spreadsheets/d/16PRB17uBRtferrNyVSPKHCyelTNW4I6m2bMaTcsgo7s/edit?usp=sharing

#
# preliminaries
#
# clear screen, use zoo for time-series, read data
#
rm(list = ls())
require("zoo")
require("tidyverse")
library(lubridate)  # better for dates,
#
##################
#   Read Labs
##################
setClass('mmddyyyy')    # create a class

# setAs(from, to, def)
# take from=Date field and transform it to  "mmddyyyy" class , which is POSIXct
# and in format we want; using POSIXct directly gives error

setAs(from = 'character', to = 'mmddyyyy',
      function(from)
          as.POSIXct(from, format = "%d%b%Y"))
#
d <-
    read.csv(
        "~/Downloads/R_projects/project_health_labs/data/2016_Health Time Series_Sheet.csv",
        header = TRUE,
        colClasses = c(Date = 'mmddyyyy'),  # convert Date to POSIXct
        na.strings = c("NA", "N/A"),  # these entries remain numbers
        # as.is=TRUE                  # not needed
        stringsAsFactors = FALSE      # do not convert to factors
    )    

d
labs <- as_tibble(d)

###################################
## read Medications
###################################

setAs(from = 'character', to = 'mmddyyyy',
      function(from)
          as.POSIXct(from, format = "%d%b%Y"))
#
meds <-
    read.csv(
        "~/Downloads/R_projects/project_health_labs/data/ongoing_Health Time Series - Medications.csv",
        header = TRUE,
        colClasses = c(Date = 'mmddyyyy'),
        # convert  Date into POSIXct               #
        na.strings = c("NA", "N/A"),
        # columns with these remain numbers
        # as.is=TRUE                  # not needed
        stringsAsFactors = FALSE
    )     # do not convert strings to factors

meds
#names(meds)[1]<- "Date2"
meds<- as_tibble(meds)


######################
# 2 tibbles:  labs & meds
#
# select fields, rows we want
######################

labs2<- labs %>%
    select(Date,Ur_Uric24) %>%
    filter(!is.na(Ur_Uric24)) %>%
    mutate(Test_name="Ur_Uric24",Test_result=Ur_Uric24, Ur_Uric24=NULL) %>%
    mutate(Grouping="Ur_Uric24")

labs2

meds2 <- meds %>%
    select(Date,Dose) %>%
    filter(!is.na(Dose)) %>%
    mutate(Grouping="Allopurinol")
meds2

##########################
## join
##  mutuating join, in which add the row, even if not in both 
##########################

join <- full_join (labs2,
                   meds2)

join2 <- as_tibble(join)
## join, tibble


########################
## Join2 - tibble - modify data as necessary
##
## (manual for now,  write code later)
#######################
join2
join2$Dose[1:3] <- 0

join2$Dose[6:8] <- 150

join2
## join3 <- filter(join2,Date != as.Date("2009-04-02"))  # remove this row
join4 <- as_tibble(join2)

#########################
## skip zoo ????
#########################
    # 
    # 
    # t <- as.POSIXct(join2$Date, format = "%Y-%m-%d")
    # 
    # # date, Test_name, Test_result,medication??, dose
    # z <- zoo(join4[,3], order.by = t)

######################

r <- factor(c(1,2))
ggplot(join4) +
    geom_point( mapping=aes(x=Date, y=Test_result), shape=22,fill="blue", size=5) +
    geom_point(mapping=aes(x=join4$Date, y=join4$Dose), color="black") +
    geom_abline(slope =0, intercept=250, color='red', lty=2) +
    geom_abline(slope =0, intercept=750, color='red', lty=2) +
    labs(
        title = "Uric Acid (24 hr), Allopurinol Dose ",
        subtitle = "Continue at 150 mg, or try 100 mg?",
        caption = "Data: Kaiser, Litholink and my records, 28DEC2016",
        y="Uric Acid (mg/day)") +
    scale_fill_continuous(guide = guide_legend(title="legend"))       
            
    

#?  Test_result vs Dose?

ggplot(join4) +
    geom_boxplot(mapping =aes(x=Dose, y=Test_result, group=Dose))
    geom_line
    
    
#########################

# how to do it!
    
x<-seq(1990,2016, by=.1)
y<-runif(n=length(x),min=0,max=1)
z<-runif(n=length(x),min=0,max=100)

    d1 <- as_tibble(cbind(x,y))
    d2 <- as_tibble(cbind(x,y=z))
    
d1$panel <- "a"
d2$panel <- "b"
d<- rbind(d1,d2)
    
p <- ggplot(data = d, mapping = aes(x = x, y = y)) + 
        facet_grid(panel~., scale="free") + 
        geom_line(data = d1, stat = "identity") + 
        geom_line(data = d2, stat = "identity")
p
