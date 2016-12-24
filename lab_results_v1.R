# Medical - Historical LAB Results
# https://docs.google.com/spreadsheets/d/16PRB17uBRtferrNyVSPKHCyelTNW4I6m2bMaTcsgo7s/edit?usp=sharing

#
# preliminaries
#


# clear screen, use zoo for time-series, read data
#
rm(list = ls())
require("zoo")
#
#


#
#   Read Data
#
setClass('mmddyyyy')    # create a class



# setAs(from, to, def)
# take from=Date field and transform it to  "mmddyyyy" class , which is POSIXct 
# and in format we want; using POSIXct directly gives error

setAs(from='character',to='mmddyyyy',
      function(from) as.POSIXct(from, format="%d%b%Y")  
              )

#
#
# 
d <- read.csv("~/Downloads/R_projects/project_health_labs/data/2016_Health Time Series_Sheet.csv",
              header=TRUE,
              colClasses=c(Date='mmddyyyy'),# convert  Date into POSIXct               #
              na.strings=c("NA","N/A"),     # columns with these remain numbers 
              # as.is=TRUE                  # not needed
              stringsAsFactors = FALSE)     # do not convert strings to factors

d
str(d)   # 27 variables
dim(d)
num_variables <- length(d)
#
#
######################



# d is data.frame
class(d)        # data.frame
str(d)          # notice, many factors
dim(d)

## TEMP fix, get rid of >60 in eGFR
d$eGFR <- as.numeric(d$eGFR)

# create time index
#
t <- as.Date(d[,1], format="%d%b%Y")


# since not periodic data, use zoo
#
# omit first 5 columns

z <- zoo(d[,6:num_variables], order.by = t) 

## names(z)   #22 variables:

#[1] "Ur_pH"           "Ur_Vol24"        "Ur_PCr"          "Ur_Oxalate24"    "Ur_Citrate24"    "Ur_Ca24"        
#[7] "Ur_Uric24"       "Ur_Cr"           "Ur_Cr24"         "BUN"             "eGFR"            "Serum_Cr"       
#[13] "Serum_Ca"        "Tot_Cholesterol" "HDL"             "LDL"             "VLDL"            "Trig"           
#[19] "TSH"             "GLU"             "A1C"             "PSA" 
#
# check (z)
#

index(z)
coredata(z)
colnames(z)
str(z)
names(z)


###############################

# PLOT everything 

# works,11 different graphs! 
# plot.type='multiple'  (not needed, but it is multiple)
#

plot(z,  type='p', col=1:21)   # needs work, but get a lot for 'free', each gets
#
#


# here we go ...


# ylim must be a list
ylim=list(
    c(5.0,9.5),      # Urine pH
    c(2.0,5.5),      # Urine Vol
    c(0.10,0.60),   # P/Creatine
    c(0,700),     # U. Oxalate
    c(500,1300),      # Ur_Citrate
    c(0,300),           # Urine Ca,
    c(200,1000),        # Ur_Uric24
    c(0,0),           # Ur_Cr spot, no bounds?
    c(0,3.0),        # Ur_Cr24
        c(10,40),   # B.U.N.
       c(50,100),     # eGFR
       c(0.5,2.0),    # Serum Cr
    c(0,12),           # serum Ca
       c(110,200),    # Total Cholesterol
       c(35,70),      # HDL
       c(80,100),     #LDL
       c(10,90),      #VLDL
       c(90,150),     # Trig
    c(0,10),       # TSH
    c(90,125),     # GLU
    c(4.5,5.8),    # A1C
    c(1.0,2.0))    # PSA


      

       
       
## change hlines back to c(24,60, ...)    

## Normal ranges
# horizontal lines (RANDOM - check!!)
hlines=list(
    6.5,      # 6.5, 7.0Urine pH
    c(2.0),      # Ur. Vol
    c(0.24),     # Ur P/Cr
     c(40),      # Ur Ox
    c(600),        # Ur, Citrate
    c(250),          # Ur, Ca ??
    c(0),          # UR Uric Acid
    c(0),       # Ur_Cr
    c(0),       # Ur Cr24
    7,     # 7,25 BUN
        c(60),     # eGFR
         c(0.6,1.3),     # Serum-Cr
    8.4,        # 8.4, 10.2 Serium Ca,
         c(239),     # Total Chol
         c(40),      # HDL
         c(159),     # LDL - check!
         c(0),      # VLDL - check
         c(499),     ## Trig - check
    c(0.34),       # 0.34, 5.6TSH
         c(100),     # GLU
         c(5.7),      # A1C
         c(0)         # PSA
    
)
        
#################################
## work on Serum_Cr only
x<-z$Serum_Cr
y<-ylim[12]
h<-hlines[12]
single_plot(series =x, limits=y,horizonal_lines=h)

single_plot <- function (series, limits,horizonal_lines){
    plot(series, type='p', 
         col=ifelse(series<=1.0,1,2),
         #mar=c(gap=0.3,5.1,gap=0.3,2.1),
         cex=1,     # size will vary 1 or 2
         pch=1,    # different symbols
        # panel=lines2,
         ylab="Serum Cr (0.6-1.30 mg/dL)",
         ylim=limits    # y limits, each panel
    )
    abline(h =0.6, 
           col = "red", 
           lty = 2,  # dotted line
           lwd = 0.5)
    
    abline(h =1.3, 
           col = "red", 
           lty = 2,  # dotted line
           lwd = 0.5)
    
    abline(v=as.Date("1/1/2014","%m/%d/%Y"), 
           col="blue", lwd=0.5)
    abline(v=as.Date("11/12/2010","%m/%d/%Y"),
           col="blue", lwd=0.5)
    abline(v=as.Date("4/1/2013","%m/%d/%Y"),
           col='green', lwd=1.0)  # didn't recheck !

    
    title(main="Serum Creatinine", xlab="")
    # legend
}

###################################

# resume multi-graph

length(hlines)
# construct these lines, by panel

lines2<-function(X,Y,type,xlab,ylab,col,pch,lty,lwd,cex){
        lines(x=X,y=Y,type="p",col=col)
        panel.number <- parent.frame()$panel.number
        abline(h = hlines[panel.number], 
               col = "red", 
               lty = 2,  # dotted line
               lwd = 0.5)
        ## ADD this glug!
        if (panel.number==1) abline(h=7.0, col='blue')
        if (panel.number==10) abline(h=25, col='blue')
        if (panel.number==13) abline(h=8.4, col='blue')
        abline(v=as.Date("1/1/2014","%m/%d/%Y"), col="brown", lwd=0.5)
}
#
#

# add margin and gap,size, symbols, colors
plot(z, type='p', col=1:12,
        mar=c(gap=0.3,5.1,gap=0.3,2.1),
        cex=1:2,     # size will vary 1 or 2
        pch=1:11,    # different symbols
        panel=lines2,
        ylim=ylim    # y limits, each panel
     )
            

title(main="Lab Results", xlab="Date")
# legend

z


