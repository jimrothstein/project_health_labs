## Cholesterol!! (to play)
## labs_results_v1.R for main code

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
require("tidyverse")
library(lubridate)  # better for dates,
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

## Select fields ------------

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

## replace with function
join<-full_join(labs2,labs3)
join <- full_join(labs7,labs8) # GLU, A1C
join
######################
## PLOT
######################

join$Grouping <- factor(join$Grouping,
                        levels=c("A1C","GLU"))  # change order

groupGLU<-subset(join,Grouping=="GLU")
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

q
   
       
  
            
    

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



 