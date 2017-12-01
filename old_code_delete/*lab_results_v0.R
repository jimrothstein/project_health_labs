library(tidyverse)
rm(list = ls())


    
# col names
names <- c("Brand","Product","Category",
               "Serving","Fat Level", "cal", 
               "fat","Sat Fat","Poly Fat",
               "Mono Fat","Cholesterol","Na", 
               "Ca","K","Sugar","D3","Protein", "Comment", 
               "X19","X20","X21")
    #
    # set atomic data type
    # Ca  needs to be percent
    t<-cols(Date="c",Where="c",Purpose="c", "Exercise Level"="c",Comments="c",
            .default="n")
    
    # t <- NULL
    # read locally 
    
    
    data <- read_csv("./data/2016_Health Time Series_Sheet.csv", 
                     col_names=TRUE,
                     col_type=t,
                     skip=0,
                     na=c("NA","N/A","",NULL))
    problems(data) # VERY helpful
    
#### read url ? ####
    # There are ways to read directly
    # See:  http://bit.ly/2xQ6mZq
    #
    # But just as easy to download .csv, not waste time
    #
    ####################
    
    
    options(tibble.print_max = Inf)
    
    data %>% filter(is.na(Ca)) %>% summarize(rows_Ca_missing=n())
    data %>% filter(is.na(Na)) %>% summarize(rows_Na_missing = n() )
    
    
