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

######## Digress POSIXt ######  (moral:  go step by step with dates)

######################## END DIGRESS ####################


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
d <- read.csv("~/Downloads/R_projects/project_Row/data/2016_Health Time Series_Sheet.csv",
              header=TRUE,
              colClasses=c(Date='mmddyyyy'),# convert  Date into POSIXct               #
              na.strings=c("NA","N/A"),     # columns with these remain numbers 
              # as.is=TRUE                  # not needed
              stringsAsFactors = FALSE)     # do not convert strings to factors

d
str(d)
#
#
#



# d is data.frame
class(d)        # data.frame
str(d)          # notice, many factors
dim(d)



# create time index
t <- as.Date(d[,1], format="%d%b%Y")



#
# eGRP   -- must replace with NUMERIC, not '>60'
#
#


# data portion (begin B.U.N, EXLUDE eGRF  '>60')
data <- d[,c(6,8:length(d))]

details(data)



# since not periodic data, use zoo
#
z <- zoo(data, order.by = t)
#
# check (z)
index(z)
coredata(z)
colnames(z)
str(z)
names(z)
#
#
# z is real zoo object!
# > names(z)
# [1] "B.U.N"           "eGFR"            "Serum.Cr"        "Ur.Oxalate"      "PSA"            
# [6] "GLU"             "A1C"             "Tot.Cholesterol" "HDL"             "LDL"            
# [11] "VLDL"            "Trig"          


############## PLOTS 1st try -clean up-    #############33

# SINGLE, A1C, for staters
plot(index(z),y=z$A1C, 
     xlab = "Time")             # simplest is best?

plot (z$A1C, type='p',ylim=c(3,8), pch=17) # points
plot (z$A1C, lty=1,ylim=c(3,8))    # line (BAD)
zoo::plot.zoo (z$A1C, type='p',ylim=c(3,8), pch=17) # points (same)


# use zoo::plot(), 
# type -- refs to points, lines, both, ...
# pch --- is character, 
# lty --- is line type
#

##################################

# A1C and GLU, 1 graph

plot(z$A1C, 
     col="blue", 
     type='p', 
     lwd=1, 
     ylim=c(0,150)) 

lines(z$GLU, col="red", type='p', lwd=1, pch=8) 
legend(x="topleft", legend=c("A1C","Glu"), col=c("blue","red"),lty=1:2) 

###########   REAL Thing ########

# PLOT everything 

# works,11 different graphs! 
# plot.type='multiple'  (not needed, but it is multiple)


plot(z,  type='p', col=1:11)   # needs work, but get a lot for 'free', each gets
                                # different color

# here we go ...

# horizontal lines (RANDOM - check!!)
hlines=c(24,     # BUN
         1.3,     # Serum-Cr
         30,      # Ur Ox
         1.7,
         100,
         5.6,
         200,     # Total Chol
         40,      # HDL
         100,     # LDL - check!
         40,      # VLDL - check
         120)     # Trig - check

# construct these lines, by panel
lines2<-function(X,Y,type,xlab,ylab,col,pch,lty,lwd,cex){
        lines(x=X,y=Y,type="p",col=col)
        panel.number <- parent.frame()$panel.number
        abline(h = hlines[panel.number], 
               col = "brown", 
               lty = "solid", 
               lwd = 0.5)
}


# add margin and gap,size, symbols
plot(z, type='p', col=1:11,
        mar=c(gap=0.3,5.1,gap=0.3,2.1),
        cex=1:2,     # size will vary 1 or 2
        pch=1:11,
        panel=lines2)    # different symbols

title(main="Lab Results", xlab="Date")
legend





#########################################################


# PLOT, more trials
plot(z[,1], col="blue", lty=1, lwd=2, ylim=c(0,50),format = "%b %Y") 
lines(z[,2], col="red", lty=2, lwd=2) 
legend(x="topleft", legend=c("A1C","Glu"), col=c("blue","red"),lty=1:2)    


#?
plot.zoo(z, type = "p", lty = 1, pch = 2,   col = 2, ylim= c(4,6))
legend(x='topleft', legend=c("A1C"),col='red', lty=1)

#
plot(z[,c(1,2)], 
     plot.type="m",     # default is multiple
     type='p', 
     col=c("blue","red"), 
     lty=c(1,2), 
     lwd=2, 
     ylim=c(c(0,50),c(0,100)),
     format = "%b %Y") 

############### end PLOT 1st Try ####################


########################
# MULTIVARIABLE

# index, using date
i <- as.Date(d[,1], format="%d%b%Y")  #23MAY2010


# data, omit dates and unneeded columns
df <- as.data.frame(d[,c(6:17)])
str(df)

z <- zoo(df, order.by=i)
class(z)
str(z)   # all chr, because of eGFR, but PLOTS work!

#
##### PLOTS ####
#
# Group
# B.U.N, eGFP
#


# try:   combine, B.U.N and eGFR in multiple graphs, note use of 'list'
# trick
# from here
# http://stackoverflow.com/questions/19314571/how-to-add-multiple-straight-lines-in-a-multi-plot-zoo

hlines <- c(c(24),c(30,60))  # not working, things this for 3 panels

my.panel <- function(x, ...) {
  lines(x, ...)
  panel.number <- parent.frame()$panel.number
  abline(h = hlines[panel.number], 
         col = "red", 
         lty = "solid", 
         lwd = 1.5)
}



plot (x=z[,1:2], 
      plot.type='multiple', 
      type="p", 
      pch=c(10,12), 
      ylim=list(c(7,50),c(30,100)), 
      panel=my.panel   )

# lines(h=list(c(24),c(30,60))  )
legend ( x="topleft", legend=list("BUN,eGFR"))


# SINGLE PLOTS


#BUN
plot(z[,1],ylim=c(7,50),type="p", pch=12, ylab="BUN")
abline(h=24)
legend(x="topleft", legend=c("B.U.N.")) 

# eGFR
plot(z[,2],ylim=c(30,100),type="p", pch=12, ylab="eGFR")
abline(h=c(30,60))
legend(x="topleft", legend=c("eGFR")) 

# Sr-Cr
plot(z[,3],ylim=c(0.6,2.0),type="p", pch=12, ylab="Serum-Cr")
abline(h=1.3)
legend(x="topleft", legend=c("Sr-Cr"))

# Ox
plot(z[,4],ylim=c(20,200),type="p", pch=12, ylab="Ox")
abline(h=c(38,90))
legend(x="topleft", legend=c("Ox")  )

# GLU
plot(z[,6],ylim=c(80,140),type="p", pch=12, ylab="GLU")
abline(h=100)
legend(x="topleft", legend=c("GLU"))

# A1C
plot(z[,7],ylim=c(4.0,6.0),type="p", pch=12, ylab="A1C")
abline(h=5.6)
legend(x="topleft", legend=c("A1C"))

# Tot Chol
plot(z[,8],ylim=c(120,200),type="p", pch=12, ylab="Total Cholesterol")
abline(h=200)
legend(x="topleft", legend=c("Tot Chol"))

# HDL
plot(z[,9],ylim=c(35,70),type="p", pch=12, ylab="HDL")
abline(h=40)
legend(x="topleft", legend=c("HDL"))

# LDL
plot(z[,10],ylim=c(30,120),type="p", pch=12, ylab="LDL")
#abline(h=1.3)
legend(x="topleft", legend=c("LDL"))

# VLDL
plot(z[,11],ylim=c(0,200),type="p", pch=12, ylab="VLDL")
#abline(h=1.3)
legend(x="topleft", legend=c("VLDL"))

# Trig
plot(z[,12],ylim=c(50,200),type="p", pch=12, ylab="Trig")
#abline(h=1.3)
legend(x="topleft", legend=c("Trig"))
