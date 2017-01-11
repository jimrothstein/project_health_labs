

rm(list = ls())
require("tidyverse")
require("zoo")
library(lubridate)
#
##################
#
#   Read Data
#
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
labs <-as_tibble(d)
labs 


# 
# # next field
# t1<- t %>%
#         select(Date,Ur_Oxalate24) %>%
#         filter(!is.na(Ur_Oxalate24)) %>%
#         mutate(Test_name = "Ur_Oxalate24")  %>%
#         mutate(Test_result = Ur_Oxalate24, Ur_Oxalate24 = NULL)
# 
# 
# our_table <- rbind(t1,t2)
# our_table
# 
# our_table <- our_table %>%
#                 arrange(Date)
# our_table
###################################
## read Medications

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
meds <- as_tibble(meds)



#####################################
## Now, have 2 tibbles
## labs
## meds

labs2<- labs %>%
    select(Date,Ur_Uric24) %>%
    filter(!is.na(Ur_Uric24)) %>%
    mutate(Test_name="Ur_Uric24",Test_result=Ur_Uric24, Ur_Uric24=NULL)

labs2

meds2 <- meds %>%
    select(Date,Dose) %>%
    filter(!is.na(Dose))

##  mutuating join, in which add the row, even if not in both 
join <- full_join (labs2,
                   meds2)

join2 <- as_tibble(join)
## join, tibble
## create zoo!


time_index <- as.POSIXct(join2[[1]])



# use zoo
#

# date, medication, dose
z <- zoo(join2[,3:4], order.by = time_index)

#

par(mfrow=c(2, 1))
#mar=c(gap=0.3, 5.1, gap=0.3, 2.1)
plot(z[,1], plot.type="s",
     type='p', ylim=c(0,1000), ylab="Ur_Uric24"
     #mar=c(gap=0.3, 5.1, gap=0.3, 2.1)
     )

plot(na.omit(z[,2]),plot.type="s",type='h', ylim=c(0,400), ylab="Allopurinol Dose")

## yeah!
ggplot(z, aes(x=index(z), y=z[,1])) +
    geom_point(shape=1)
#####################################################
## CUTE example  - read txt files

#tags: dput, read.table(), text file, txt,
rm(list=ls())
df1 = read.table("df1.txt", 
                 header=TRUE,
                 sep=",", 
                 col.names=c("date", "count"), 
                 fill=FALSE, 
                 strip.white=TRUE)

df2 = read.table("df2.txt", 
                 header=TRUE,
                 sep=",", 
                 col.names=c("date", "count"), 
                 fill=FALSE, 
                 strip.white=TRUE)
df1$date <-as.POSIXct(df1$date)
df1$type <- "df1"
df2$date <-as.POSIXct(df2$date)
df2$type <- "df2"
df1
df2

df <- rbind(df1,df2)
df

dput(df)    # text version of df object


library(ggplot2)
ggplot(df, aes(x = date, y = count, color=type)) + 
    geom_line() + 
    theme_bw()
##############################################


