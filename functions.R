##################
# 001_load_packages
##################

load_packages <- function() {
    options(width=70)
    options(useFancyQuotes=FALSE)
    if (!require(lubridate)) {
        install.packages("lubridate")
    }
    require("lubridate")
    require("tidyverse")
    return("all pkgs loaded successfully")
}


##################
#   002_Read Labs
##################
read_data_from_local_drive <- function(){
    # .Deprecated("*** write function using URL ***")
  
# 28 fields  
    # cols_only() --  to read specified cols (omitting others)
    # .... if lazy  use col_types=cols( .default=col_guess())
    # cols() --  to read every
    # type is list
    type <- cols_only(Date = col_date(format="%d%b%Y"),   # parse 09APR2010
              Where = "c",
              Purpose = "c",
              "Exercise Level" = "c",
              Comments = "c",
              Ur_pH = "n",
              Ur_Vol24 = "n",
              Ur_PCr = "n",
              Ur_Oxalate24 = "n",
              Ur_Ca24 = "n",
              Ur_Uric24 = "n",
              Ur_Cr = "n",
              Ur_Cr24 = "n",
              BUN = "n",
              eGFR = "n",
              Serum_Cr = "n",
              Serum_Ca = "n",
              Tot_Cholesterol = "n",
              HDL = "n",
              LDL = "n",
              VLDL ="n",
              Trig = "n",
              TSH = "n",
              GLU =  "n",
              A1C =  "n",
              PSA = "n",
              Allopurinol = "n"
              )
    
    d<-read_csv(file=
        "data/2016_Health Time Series_Sheet.csv",
        col_names = TRUE, # use 1st line
        col_types = type, # or cols( .default = col_guess() ), 
        na = c("NA", "N/A")  # these entries remain numbers
    )
    return(d)
}
##############
# 003_save_norm_to_local
##############


save_norm_to_local<- function(t=tibble){
    
    # if not tibble, stop!
    if (!is.tibble(t) || is.null(t)) {stop("must supply tibble")}
    
    write_csv(x=t, "./data/pre_2017_labs_norm.csv")
    return (TRUE)
}

