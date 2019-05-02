library("dplyr")

mydir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(mydir)
setwd("..")
setwd("..")

fname1 <- "data/processed/demographic_processed.csv"
fname2 <- "data/processed/campaign_processed.csv" 
fname3 <- "data/processed/last_call_processed.csv"
fname4 <- "data/processed/macro_econ_processed.csv"

demographic_df      <- read.csv(fname1, sep=";")
demographic_df_no_y <- select(demographic_df, -"y")

campaign_df         <- read.csv(fname2, sep=";")
campaign_df_no_y    <- select(campaign_df, -"y")

last_call_df        <- read.csv(fname3, sep=";")
last_call_no_y      <- select(last_call_df, -"y")

macro_econ_df       <- read.csv(fname4, sep=";")


out <- cbind(demographic_df_no_y, campaign_df_no_y, last_call_no_y, macro_econ_df)

setwd("data/processed/")
write.table(out, file="bank_full_processed.csv", sep=";", row.names=FALSE)
