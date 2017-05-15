----

## lab_results_v3.R
## 
----
## Changes:   functions, NO facets, use separate plots, save
## Tags:    ggsave,

# Medical - Historical LAB Results
# https://docs.google.com/spreadsheets/d/16PRB17uBRtferrNyVSPKHCyelTNW4I6m2bMaTcsgo7s/edit?usp=sharing

#######################
#  Variables to plot
#######################
# Tot_Cholesterol
# HDL
# LDL
# VLDL
# Trig
# GLU
# A1C
# WT

#######################
# preliminaries
# clear screen
######################

rm(list = ls())


######################
# source functions
######################

source("functions.R")


# Main code

################
# load packages
################

.First()

###############
# download  data
###############

labs<-experiment()


###################
## Tidy
###################

z<-labs %>%
        gather(key="Test_Names",value="Test_Result",         # create 2 new columns
         -c(Date,Where,Purpose,Exercise.Level,Comments,Allopurinol),  # exclude
         na.rm=TRUE)  # except for these columns, insert all the data

result<-z %>% select(Date,Test_Names, Test_Result)
print(result,n=100)

#################
# save result
#################

store(result)

#####################
## STOP
#####################


