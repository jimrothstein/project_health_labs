#005_plots.R


#################
# plots
#################

####
# Test
####
g <-  ggplot(result, aes(x=Date, y=Test_Result)) +
    facet_wrap(~Test_Name, nrows=5)

 g + geom_point()

####################
g <-filter(result, Test_Name == "eGFR") %>% 
    ggplot(aes(x=Date, y=Test_Result))
g + geom_point()

g <-filter(result, Test_Name == "Trig") %>% 
    ggplot(aes(x=Date, y=Test_Result))
g + geom_point()

g <-filter(result, Test_Name == "Ur_Oxalate24") %>% 
    ggplot(aes(x=Date, y=Test_Result))
g + geom_point()

g <-filter(result, Test_Name == "GLU") %>% 
    ggplot(aes(x=Date, y=Test_Result))
g + geom_point()

