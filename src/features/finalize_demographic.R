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
fname         <- "data/interim/demographic.csv" 
Mers$dataset <- read.csv(fname,
                        sep=";",
                        na.strings=c(".", "NA", "", "?"),
                        strip.white=TRUE, encoding="UTF-8")

#=======================================================================
# Rattle timestamp: 2019-04-22 19:40:27 x86_64-pc-linux-gnu 

# Transform variables by rescaling. 

# The 'reshape' package provides the 'rescaler' function.

library(reshape, quietly=TRUE)

# Rescale age.

Mers$dataset[["R01_age"]] <- Mers$dataset[["age"]]

# Rescale to [0,1].

if (building)
{
  Mers$dataset[["R01_age"]] <-  rescaler(Mers$dataset[["age"]], "range")
}

# When scoring transform using the training data parameters.

if (scoring)
{
  Mers$dataset[["R01_age"]] <- (Mers$dataset[["age"]] - 17.000000)/abs(98.000000 - 17.000000)
}


#=======================================================================
# Rattle timestamp: 2019-04-22 19:40:39 x86_64-pc-linux-gnu 

# Remap variables. 

# Turn a factor into indicator variables.

Mers$dataset[, make.names(paste("TIN_job_", levels(Mers$dataset[["job"]]), sep=""))] <- diag(nlevels(Mers$dataset[["job"]]))[Mers$dataset[["job"]],]

Mers$dataset[, make.names(paste("TIN_marital_", levels(Mers$dataset[["marital"]]), sep=""))] <- diag(nlevels(Mers$dataset[["marital"]]))[Mers$dataset[["marital"]],]

Mers$dataset[, make.names(paste("TIN_education_", levels(Mers$dataset[["education"]]), sep=""))] <- diag(nlevels(Mers$dataset[["education"]]))[Mers$dataset[["education"]],]

Mers$dataset[, make.names(paste("TIN_default_", levels(Mers$dataset[["default"]]), sep=""))] <- diag(nlevels(Mers$dataset[["default"]]))[Mers$dataset[["default"]],]

Mers$dataset[, make.names(paste("TIN_housing_", levels(Mers$dataset[["housing"]]), sep=""))] <- diag(nlevels(Mers$dataset[["housing"]]))[Mers$dataset[["housing"]],]

Mers$dataset[, make.names(paste("TIN_loan_", levels(Mers$dataset[["loan"]]), sep=""))] <- diag(nlevels(Mers$dataset[["loan"]]))[Mers$dataset[["loan"]],]


# The following variable selections have been noted.

Mers$input     <- c("R01_age", "TIN_job_admin.",
                   "TIN_job_blue.collar", "TIN_job_entrepreneur",
                   "TIN_job_housemaid", "TIN_job_management",
                   "TIN_job_retired", "TIN_job_self.employed",
                   "TIN_job_services", "TIN_job_student",
                   "TIN_job_technician", "TIN_job_unemployed",
                   "TIN_marital_divorced", "TIN_marital_married",
                   "TIN_marital_single", "TIN_education_basic.4y",
                   "TIN_education_basic.6y",
                   "TIN_education_basic.9y",
                   "TIN_education_high.school",
                   "TIN_education_illiterate",
                   "TIN_education_professional.course",
                   "TIN_education_university.degree",
                   "TIN_default_no", "TIN_default_yes",
                   "TIN_housing_no", "TIN_housing_yes",
                   "TIN_loan_no", "TIN_loan_yes")

Mers$numeric   <- c("R01_age", "TIN_job_admin.",
                   "TIN_job_blue.collar", "TIN_job_entrepreneur",
                   "TIN_job_housemaid", "TIN_job_management",
                   "TIN_job_retired", "TIN_job_self.employed",
                   "TIN_job_services", "TIN_job_student",
                   "TIN_job_technician", "TIN_job_unemployed",
                   "TIN_marital_divorced", "TIN_marital_married",
                   "TIN_marital_single", "TIN_education_basic.4y",
                   "TIN_education_basic.6y",
                   "TIN_education_basic.9y",
                   "TIN_education_high.school",
                   "TIN_education_illiterate",
                   "TIN_education_professional.course",
                   "TIN_education_university.degree",
                   "TIN_default_no", "TIN_default_yes",
                   "TIN_housing_no", "TIN_housing_yes",
                   "TIN_loan_no", "TIN_loan_yes")

Mers$categoric <- NULL

Mers$target    <- "y"
Mers$risk      <- NULL
Mers$ident     <- NULL
Mers$ignore    <- c("age", "job", "marital", "education", "default", "housing", "loan", "TIN_job_unknown", "TIN_marital_unknown", "TIN_education_unknown", "TIN_default_unknown", "TIN_housing_unknown", "TIN_loan_unknown")
Mers$weights   <- NULL

setwd("data/processed/")
write.table(select(Mers$dataset, Mers$input, Mers$target), file="demographic_processed.csv", sep=";", row.names=FALSE)
