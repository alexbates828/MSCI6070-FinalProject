#library(rattle)   # Access the weather dataset and utilities.
library(magrittr) # Utilise %>% and %<>% pipeline operators.
library("dplyr")

# This log generally records the process of building a model. 
# However, with very little effort the log can also be used 
# to score a new dataset. The logical variable 'building' 
# is used to toggle between generating transformations, 
# when building a model and using the transformations, 
# when scoring a dataset.

building <- TRUE
scoring  <- ! building

# A pre-defined value is used to reset the random seed 
# so that results are repeatable. 

# Rattle uses internal variables crs and crv to keep
# track of everything. I renamed these Mers and Merv, 
# respectively. 
Mers <- c()
Merv <- c()

#=======================================================================
# Rattle timestamp: 2019-04-22 19:39:46 x86_64-pc-linux-gnu 

# Load a dataset from file.

mydir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(mydir)
setwd("..")
setwd("..")
fname         <- "data/interim/last_call.csv" 
Mers$dataset <- read.csv(fname,
                         sep=";",
                         na.strings=c(".", "NA", "", "?"),
                         strip.white=TRUE, encoding="UTF-8")

#=======================================================================
# Rattle timestamp: 2019-04-23 09:59:16 x86_64-pc-linux-gnu 

# Remap variables. 

# Turn a factor into indicator variables.

Mers$dataset[, make.names(paste("TIN_contact_", levels(Mers$dataset[["contact"]]), sep=""))] <- diag(nlevels(Mers$dataset[["contact"]]))[Mers$dataset[["contact"]],]

Mers$dataset[, make.names(paste("TIN_month_", levels(Mers$dataset[["month"]]), sep=""))] <- diag(nlevels(Mers$dataset[["month"]]))[Mers$dataset[["month"]],]

Mers$dataset[, make.names(paste("TIN_day_of_week_", levels(Mers$dataset[["day_of_week"]]), sep=""))] <- diag(nlevels(Mers$dataset[["day_of_week"]]))[Mers$dataset[["day_of_week"]],]

# Transform variables by rescaling. 

library(reshape, quietly=TRUE)

# Rescale duration.

Mers$dataset[["R01_duration"]] <- Mers$dataset[["duration"]]

# Rescale to [0,1].

if (building)
{
  Mers$dataset[["R01_duration"]] <-  rescaler(Mers$dataset[["duration"]], "range")
}

# When scoring transform using the training data parameters.

if (scoring)
{
  Mers$dataset[["R01_duration"]] <- (Mers$dataset[["duration"]] - 0.000000)/abs(4918.000000 - 0.000000)
}

# The following variable selections have been noted.

Mers$input     <- c("TIN_contact_cellular", "TIN_month_apr",
                   "TIN_month_aug", "TIN_month_jul", "TIN_month_jun",
                   "TIN_month_mar", "TIN_month_may", "TIN_month_nov",
                   "TIN_month_oct", "TIN_month_sep",
                   "TIN_day_of_week_mon", "TIN_day_of_week_thu",
                   "TIN_day_of_week_tue", "TIN_day_of_week_wed",
                   "R01_duration")

Mers$numeric   <- c("TIN_contact_cellular", "TIN_month_apr",
                   "TIN_month_aug", "TIN_month_jul", "TIN_month_jun",
                   "TIN_month_mar", "TIN_month_may", "TIN_month_nov",
                   "TIN_month_oct", "TIN_month_sep",
                   "TIN_day_of_week_mon", "TIN_day_of_week_thu",
                   "TIN_day_of_week_tue", "TIN_day_of_week_wed",
                   "R01_duration")

Mers$categoric <- NULL

Mers$target    <- "y"
Mers$risk      <- NULL
Mers$ident     <- NULL
Mers$ignore    <- c("contact", "month", "day_of_week", "duration", "TIN_contact_telephone", "TIN_month_dec", "TIN_day_of_week_fri")
Mers$weights   <- NULL

setwd("data/processed/")
write.table(select(Mers$dataset, Mers$input, Mers$target), file="last_call_processed.csv", sep=";", row.names=FALSE)
