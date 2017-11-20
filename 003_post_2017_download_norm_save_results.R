#003_post_2017_download_norm_saveresults.R

rm(list=ls())

require(tidyverse)

###########
# read 2017-on data from local into tibble
###########


# cols_only() --  to read specified cols (omitting others)
    # .... if lazy  use col_types=cols( .default=col_guess())
    # cols() --  to read every
    # type is list

    type <- cols_only(Date = col_date(format="%d%b%Y"),   # parse 09APR2010    
        Test_Name="c",
        Test_Result="n")  
    
    result<-read_csv(file=
        "data/2017_Health Time Series_Sheet.csv",
        na = c("NA", "N/A"),  # these entries remain numbers
        col_names = TRUE,  # use 1st line,
     col_types = type
     
    )   

result<- result %>% dplyr::select(Date,Test_Name, Test_Result) %>% 
    
    dplyr::arrange(Date)


###########
# save 2017+ data to local
###########
f<-"./data/2017_labs_norm.csv"
    write.csv(file= f, x=result, row.names=FALSE)
    
    
    
z <- result %>% filter(Test_Name== "GLU")

g <- ggplot(z, aes(x=Date, y=Test_Result))
g + geom_point()
