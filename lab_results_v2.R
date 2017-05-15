## lab_results_v2.R
## 

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
# clear screen,  read data
#
rm(list = ls())

#####  Add this ####
.First <- function() {
    options(width=70)
    options(useFancyQuotes=FALSE)
    require(lubridate)
    require(tidyverse)
    theme_set(theme_bw())
    #png <<- function(res=96, width=500, height=300, ...) 
    #   grDevices::png(res=res, width=width, height=height, ...)
}
#### ####
.First()
#
##################
#   Read Labs
##################
experiment <- function(){
    d<-read.csv(
        "~/Downloads/R_projects/project_health_labs/data/2016_Health Time Series_Sheet.csv",
        header = TRUE,
        na.strings = c("NA", "N/A"),  # these entries remain numbers
        # as.is=TRUE                  # not needed
        stringsAsFactors = FALSE      # do not convert to factors
    )
    
    # char to Date
    d$Date<-dmy(d$Date)
    labs<-as_tibble(d)
    return(labs)
}
labs<- experiment()
labs


###################
## Tidy
###################

z<- labs %>%
    gather( Ur_Oxalate24,   # 1 columns (include as many col as desired)
           key="Test_Names",        # insert col name into ths column (Test_Names)
           value="Value")     # insert value here

z %>% select(Date,Test_Names, Value)   # Normalized!



#####################
## Select fields  (SKIP!?)
#####################

labs2<- labs %>%
    select(Date,Tot_Cholesterol) %>%
    filter(!is.na(Tot_Cholesterol)) %>%
    # adding Grouping, column for Value, remove column Tot_Choleterol
    mutate(Grouping="Tot_Cholesterol", Value=Tot_Cholesterol, Tot_Cholesterol=NULL)

labs2

labs3<- labs %>%
    select (Date, HDL) %>%
    filter(!is.na(HDL)) %>%
    mutate(Grouping="HDL", Value=HDL, HDL=NULL)
labs3

labs4<- labs %>%
    select (Date, LDL) %>%
    filter(!is.na(LDL)) %>%
    mutate(Grouping="LDL", Value=LDL, LDL=NULL)
labs4

labs5<- labs %>%
    select (Date, VLDL) %>%
    filter(!is.na(VLDL)) %>%
    mutate(Grouping="VLDL", Value=VLDL, VLDL=NULL)
labs5

labs6<- labs %>%
    select (Date, Trig) %>%
    filter(!is.na(Trig)) %>%
    mutate(Grouping="Trig", Value=Trig, Trig=NULL)
labs6

labs7<- labs %>%
    select (Date, GLU) %>%
    filter(!is.na(GLU)) %>%
    mutate(Grouping="GLU", Value=GLU, GLU=NULL)
labs7

labs8<- labs %>%
    select (Date, A1C) %>%
    filter(!is.na(A1C)) %>%
    mutate(Grouping="A1C", Value=A1C, A1C=NULL)
labs8

labs9 <- labs %>%
    select(Date, Ur_Oxalate24) %>%
    filter(!is.na(Ur_Oxalate24)) %>%
    mutate(Grouping="Ur_Oxalate24", Value=Ur_Oxalate24, Ur_Oxalate24=NULL)
labs9

## replace with function
join<-full_join(labs2,labs3)
join <- full_join(labs7,labs8) # GLU, A1C
join <- full_join(labs,labs9) # Ur_Oxalate24
join
######################
## PLOT
######################

join$Grouping <- factor(join$Grouping,
                        levels=c("A1C","GLU"))  # change order
join$Grouping <- factor(join$Grouping)  # Ur_Oxalate

groupGLU<-subset(join,Grouping=="GLU")

########################
## Facets (SKIP)
########################
p <- ggplot(data=join, aes(x=Date, y=Value)) +
    facet_grid(Grouping~., scales = "free_y" ) +
    geom_point() +
    geom_vline(
        aes(xintercept=as.numeric(as.Date("1/1/2014","%m/%d/%Y")), 
            color="blue", lwd=0.5)) +
    
    #geom_abline(slope =0, intercept=122, color='red', lty=2) +
    #geom_abline(slope =0, intercept=200, color='red', lty=2) +
    #geom_line(data = labs$Tot_Cholesterol, stat = "identity") + 
    #geom_line(data = labs$HDL, stat = "identity")+
    labs(
        title = "Cholesterol ",
        subtitle = "-- subtitle ",
        caption = "Data: Kaiser and my records, 28DEC2016")
# somehow this works!
# see: decorating: https://www3.nd.edu/~steve/computing_with_data/13_Facets/facets.html
q<- p + geom_point(data=groupGLU, color="red") 

# but not this....        
# scale_y_continuous(data=groupGLU, name = "GLU", limits= c(80,150)) 
#                                                                   

##########################
##  Instead, 1 graph at a time, use ggsave
##########################


p<-ggplot(data=z,aes(x=Date,y=Value)) +
    geom_point()+
    geom_hline(yintercept=35, linetype="dashed", color='red') +
    labs(
        title = "Ur_Oxalate24 ",
        subtitle = "normal: <35 ",
        caption = "Data: Kaiser and Litholink, 28DEC2016")

p
ggsave(filename = "Ur_Oxalate24.bmp")






#