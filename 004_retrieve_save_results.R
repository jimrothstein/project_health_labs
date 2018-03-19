#004_retrieve_saved_results_combine.R

##############
# initialize
##############

rm(list=ls())
require(tidyverse)


############
# read pre-2017 norm data
############
result <- read_csv("./data/pre_2017_labs_norm.csv")

############
# read 2017+ norm data
############
result2 <- read_csv("./data/2017_labs_norm.csv")


############
# combine pre and post 2017
############

theresult <- rbind(result,result2)
write_csv(x=theresult, path ="./data/combine_labs_norm.csv")

############
# confirm no strs -> factors;   check glimpse
############
glimpse(read_csv("./data/combine_labs_norm.csv"))
