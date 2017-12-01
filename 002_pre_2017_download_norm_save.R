####################
## 002_pre_2017_download_norm_save.R
#################### 

## Tags:    ggsave,

#######################
# Medical - Historical LAB Results
# https://docs.google.com/spreadsheets/d/16PRB17uBRtferrNyVSPKHCyelTNW4I6m2bMaTcsgo7s/edit?usp=sharing
#######################


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
rm(list=ls())

######################
# source functions
######################

source("functions.R")

################
# load packages
################

load_packages()

###############
# read pre-2017 data from local drive
###############
labs <-read_data_from_local_drive()

###################
## Tidy (normalize)
###################
z<-labs %>%
        gather(key="Test_Name",
               value="Test_Result",         # create 2 new columns
                 -c(Date,Where,Purpose,`Exercise Level`,
                Comments,Allopurinol),  # do not 'gather' these columns
         na.rm=TRUE) 

result<-z %>% dplyr::select(Date,Test_Name, Test_Result) %>% 
    dplyr::arrange(Date)

print(result,n=100)

#################
# save result
#################

# save pre-2017 results
save_norm_to_local(result)
#################



