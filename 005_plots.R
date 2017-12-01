#005_plots.R




#################
# Retrieve normalized, data 2009 - present (local)
#################
result <- read_r::read_csv("./data/combine_labs_norm.csv")




# plots
#################

####
# Test
####

z <- result %>% filter(Test_Name== "GLU")
g <- ggplot(z, aes(x=Date,y=Test_Result)) 
g + geom_point() +
    scale_x_date(date_labels = "%Y") +
    geom_hline(yintercept = 100, color="red") +
    labs (title = "Fasting Glucose",
          subtitle = "2009 - 2018") +

    geom_vline(aes(xintercept = 
            as.numeric(
                ymd(c("2012-01-01","2015-05-01"))
                )
                ),color="blue")
            

# problem:  y-axis is fixed!
g <-  ggplot(result, aes(x=Date, y=Test_Result)) +
    facet_wrap(~Test_Names)

 g + geom_point()
 




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

