
##################
# First
##################

First <- function() {
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
    return(TRUE)
}


##################
#   Read Labs
##################

experiment <- function(){
    .Deprecated("*** write function using URL ***")
    d<-read.csv(file=
        "data/2016_Health Time Series_Sheet.csv",
        header = TRUE,
        na.strings = c("NA", "N/A"),  # these entries remain numbers
        # as.is=TRUE                  # not needed
        stringsAsFactors = FALSE      # do not convert to factors
    )
    
    # some clean up: char to Date
    d$Date<-dmy(d$Date)
    labs<-as_tibble(d)
    return(labs)
}

##############
# preliminary:  function to store tibble as .csv
##############

store<- function(t=tibble){
    
    # if not tibble, stop!
    if (!is.tibble(t) || is.null(t)) {stop("must supply tibble")}
    
    f<-"./data/labs_norm.csv"
    write.csv(file= f, x=t)
    return (TRUE)
}

Last<-function(l=FALSE){
    
    if (l){
        # remove function, so will be need to be resourced
        rm(First)
    }
}       
