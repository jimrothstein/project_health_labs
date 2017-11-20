#004_retrieve_saved_results_combine.R
rm(list=ls())
require(tidyverse)


############
# read pre-2017 norm data
############
result <- read.csv("./data/pre_2017_labs_norm.csv")

############
# read 2017+ norm data
############
result2 <- read.csv("./data/2017_labs_norm.csv")


############
# combine pre and post 2017
############

theresult <- rbind(result,result2)
write.csv(x=theresult, file="./data/combine_labs_norm.csv")


z <- theresult %>% filter(Test_Name== "GLU")
g <- ggplot(z, aes(x=Date,y=Test_Result))
g + geom_point()


# problem:  y-axis is fixed!
g <-  ggplot(result, aes(x=Date, y=Test_Result)) +
    facet_wrap(~Test_Names)

 g + geom_point()
 