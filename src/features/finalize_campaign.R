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
fname         <- "data/interim/campaign.csv" 
Mers$dataset <- read.csv(fname,
                         sep=";",
                         na.strings=c(".", "NA", "", "?"),
                         strip.white=TRUE, encoding="UTF-8")

# Rattle timestamp: 2019-04-23 12:10:23 x86_64-pc-linux-gnu 

# Transform variables by rescaling. 

# The 'reshape' package provides the 'rescaler' function.

library(reshape, quietly=TRUE)

# Rescale previous.

Mers$dataset[["R01_previous"]] <- Mers$dataset[["previous"]]

# Rescale to [0,1].

if (building)
{
  Mers$dataset[["R01_previous"]] <-  rescaler(Mers$dataset[["previous"]], "range")
}

# When scoring transform using the training data parameters.

if (scoring)
{
  Mers$dataset[["R01_previous"]] <- (Mers$dataset[["previous"]] - 0.000000)/abs(7.000000 - 0.000000)
}

Mers$dataset[, make.names(paste("TIN_poutcome_", levels(Mers$dataset[["poutcome"]]), sep=""))] <- diag(nlevels(Mers$dataset[["poutcome"]]))[Mers$dataset[["poutcome"]],]

# Rescale campaign.

Mers$dataset[["R01_campaign"]] <- Mers$dataset[["campaign"]]

# Rescale to [0,1].

if (building)
{
  Mers$dataset[["R01_campaign"]] <-  rescaler(Mers$dataset[["campaign"]], "range")
}

# When scoring transform using the training data parameters.

if (scoring)
{
  Mers$dataset[["R01_campaign"]] <- (Mers$dataset[["campaign"]] - 1.000000)/abs(56.000000 - 1.000000)
}

# The following variable selections have been noted.

Mers$input     <- c("sim_pdays", "R01_previous",
                   "TIN_poutcome_failure", "TIN_poutcome_success",
                   "R01_campaign")

Mers$numeric   <- c("sim_pdays", "R01_previous",
                   "TIN_poutcome_failure", "TIN_poutcome_success",
                   "R01_campaign")

Mers$categoric <- NULL

Mers$target    <- "y"
Mers$risk      <- NULL
Mers$ident     <- NULL
Mers$ignore    <- c("campaign", "previous", "poutcome", "TIN_poutcome_nonexistent")
Mers$weights   <- NULL

setwd("data/processed/")
write.table(select(Mers$dataset, Mers$input, Mers$target), file="campaign_processed.csv", sep=";", row.names=FALSE)
