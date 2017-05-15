
##################
# .First
##################

.First <- function() {
    options(width=70)
    options(useFancyQuotes=FALSE)
    if (!require(lubridate)) {
        install.packages("lubridate")
    }
    if (!require(tidyverse)) {
        install.packages("tidyverse")
        require("tidyverse")
    }
}



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

##############
# preliminary:  function to store tibble as .csv
##############

store<- function(t=tibble){
    print(result)
    f<-"./data/labs_norm.csv"
    write.csv(file= f, x=t)
    
}
