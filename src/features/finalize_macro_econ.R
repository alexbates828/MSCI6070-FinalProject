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
fname         <- "data/interim/macro_econ.csv" 
Mers$dataset <- read.csv(fname,
                         sep=";",
                         na.strings=c(".", "NA", "", "?"),
                         strip.white=TRUE, encoding="UTF-8")

# Rescale emp.var.rate.

Mers$dataset[["RRC_emp.var.rate"]] <- Mers$dataset[["emp.var.rate"]]

# Recenter and rescale the data around 0.

if (building)
{
  Mers$dataset[["RRC_emp.var.rate"]] <-
    scale(Mers$dataset[["emp.var.rate"]])[,1]
}

# When scoring transform using the training data parameters.

if (scoring)
{
  Mers$dataset[["RRC_emp.var.rate"]] <- (Mers$dataset[["emp.var.rate"]] - 0.081886)/1.570960
}

# Rescale cons.price.idx.

Mers$dataset[["RRC_cons.price.idx"]] <- Mers$dataset[["cons.price.idx"]]

# Recenter and rescale the data around 0.

if (building)
{
  Mers$dataset[["RRC_cons.price.idx"]] <-
    scale(Mers$dataset[["cons.price.idx"]])[,1]
}

# When scoring transform using the training data parameters.

if (scoring)
{
  Mers$dataset[["RRC_cons.price.idx"]] <- (Mers$dataset[["cons.price.idx"]] - 93.575664)/0.578840
}

# Rescale cons.conf.idx.

Mers$dataset[["RRC_cons.conf.idx"]] <- Mers$dataset[["cons.conf.idx"]]

# Recenter and rescale the data around 0.

if (building)
{
  Mers$dataset[["RRC_cons.conf.idx"]] <-
    scale(Mers$dataset[["cons.conf.idx"]])[,1]
}

# When scoring transform using the training data parameters.

if (scoring)
{
  Mers$dataset[["RRC_cons.conf.idx"]] <- (Mers$dataset[["cons.conf.idx"]] - -40.502600)/4.628198
}

# Rescale euribor3m.

Mers$dataset[["RRC_euribor3m"]] <- Mers$dataset[["euribor3m"]]

# Recenter and rescale the data around 0.

if (building)
{
  Mers$dataset[["RRC_euribor3m"]] <-
    scale(Mers$dataset[["euribor3m"]])[,1]
}

# When scoring transform using the training data parameters.

if (scoring)
{
  Mers$dataset[["RRC_euribor3m"]] <- (Mers$dataset[["euribor3m"]] - 3.621291)/1.734447
}

# Rescale nr.employed.

Mers$dataset[["RRC_nr.employed"]] <- Mers$dataset[["nr.employed"]]

# Recenter and rescale the data around 0.

if (building)
{
  Mers$dataset[["RRC_nr.employed"]] <-
    scale(Mers$dataset[["nr.employed"]])[,1]
}

# When scoring transform using the training data parameters.

if (scoring)
{
  Mers$dataset[["RRC_nr.employed"]] <- (Mers$dataset[["nr.employed"]] - 5167.035911)/72.251528
}

#=======================================================================
# Rattle timestamp: 2019-04-22 21:16:10 x86_64-pc-linux-gnu 

# Action the user selections from the Data tab. 

# The following variable selections have been noted.

Mers$input     <- c("RRC_emp.var.rate", "RRC_cons.price.idx",
                   "RRC_cons.conf.idx", "RRC_euribor3m",
                   "RRC_nr.employed")

Mers$numeric   <- c("RRC_emp.var.rate", "RRC_cons.price.idx",
                   "RRC_cons.conf.idx", "RRC_euribor3m",
                   "RRC_nr.employed")

Mers$categoric <- NULL

Mers$target    <- "y"
Mers$risk      <- NULL
Mers$ident     <- NULL
Mers$ignore    <- c("emp.var.rate", "cons.price.idx", "cons.conf.idx", "euribor3m", "nr.employed")
Mers$weights   <- NULL

setwd("data/processed/")
write.table(select(Mers$dataset, Mers$input, Mers$target), file="macro_econ_processed.csv", sep=";", row.names=FALSE)
