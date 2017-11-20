

## 002_pre_2017_download_norm_save.R
#################### 

## Changes:   functions, NO facets, use separate plots, save
## Tags:    ggsave,

#######################
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
rm(list=ls())

######################
# source functions
######################
#source("functions.R")
            # ToDo(jim) 
            # loaded? then do not repeat
            # if (!exists(".First", mode="function")) {
              #source("functions.R")
            #}

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



##################
# 001_load_packages
##################

load_packages <- function() {
    options(width=70)
    options(useFancyQuotes=FALSE)
    if (!require(lubridate)) {
        install.packages("lubridate")
    }
    require("lubridate")
    require("tidyverse")
    # if (!require(tidyverse)) {
    #     install.packages("tidyverse")
    #     require("tidyverse")
    # }
    return("all pkgs loaded successfully")
}


##################
#   Read Labs
##################
read_data_from_local_drive <- function(){
    # .Deprecated("*** write function using URL ***")
  
# 28 fields  
    # cols_only() --  to read specified cols (omitting others)
    # .... if lazy  use col_types=cols( .default=col_guess())
    # cols() --  to read every
    # type is list
    type <- cols_only(Date = col_date(format="%d%b%Y"),   # parse 09APR2010
              Where = "c",
              Purpose = "c",
              "Exercise Level" = "c",
              Comments = "c",
              Ur_pH = "n",
              Ur_Vol24 = "n",
              Ur_PCr = "n",
              Ur_Oxalate24 = "n",
              Ur_Ca24 = "n",
              Ur_Uric24 = "n",
              Ur_Cr = "n",
              Ur_Cr24 = "n",
              BUN = "n",
              eGFR = "n",
              Serum_Cr = "n",
              Serum_Ca = "n",
              Tot_Cholesterol = "n",
              HDL = "n",
              LDL = "n",
              VLDL ="n",
              Trig = "n",
              TSH = "n",
              GLU =  "n",
              A1C =  "n",
              PSA = "n",
              Allopurinol = "n"
              )
    
    d<-read_csv(file=
        "data/2016_Health Time Series_Sheet.csv",
        col_names = TRUE, # use 1st line
        col_types = type, # or cols( .default = col_guess() ), 
        na = c("NA", "N/A")  # these entries remain numbers
    )
    return(d)
     # ToDo(parse 02Apr2009)eturn(labs)
}
##############
# preliminary:  function to store tibble as .csv
##############

save_norm_to_local<- function(t=tibble){
    
    # if not tibble, stop!
    if (!is.tibble(t) || is.null(t)) {stop("must supply tibble")}
    
    f<-"./data/pre_2017_labs_norm.csv"
    write.csv(file= f, x=t, row.names = FALSE)
    return (TRUE)
}

