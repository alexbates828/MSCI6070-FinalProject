# This script takes the full data file, bank-additional-full.csv and 
# partitions it into four subsets based on the features. 

library("dplyr")

mydir <- dirname(rstudioapi::getSourceEditorContext()$path) # get path of the current file
setwd(mydir) 
setwd("..")
setwd("..")

# Read in the data as a frame
df <- data.frame(read.csv("data/raw/bank-additional/bank-additional/bank-additional-full.csv", sep=";"))

###########################################################################
# First partition: By demographic information
demographic_colnames <- c("age", "job", "marital", "education", "default", "housing", "loan", "y")
demographic_df <- select(df, demographic_colnames)
write.table(demographic_df, file="data/interim/demographic.csv", sep=";", row.names=FALSE)
remove(demographic_df)

###########################################################################
# Second partition: By the information associated with the call itself 
last_call_colnames <- c("contact", "month", "day_of_week", "duration", "y")
last_call_df <- select(df, last_call_colnames)
write.table(last_call_df, file="data/interim/last_call.csv", sep=";", row.names=FALSE)
remove(last_call_df)

###########################################################################
# Third partition: By the information from the previous campaign
campaign_colnames <- c("campaign", "pdays", "previous", "poutcome", "y")
campaign_df <- select(df, campaign_colnames)
# Variable "pdays" is coded to 999 if the client was not contacted previously. 
# I'm going to change this variable altogether. Instead of distance, we will
# measure similarity. 
# we have a few zeros in the data, so everything will need to be +1 before we invert

campaign_df$sim_pdays <- campaign_df$pdays
campaign_df$sim_pdays <- campaign_df$sim_pdays + 1

# now invert everything
campaign_df$sim_pdays <- 1/campaign_df$sim_pdays

#turn everything which was (999 + 1 =)1000 to 0. 
campaign_df$sim_pdays[which(campaign_df$sim_pdays==0.001)] <- 0

# remove attribute pdays before writing to file 
campaign_df$pdays <- NULL

write.table(campaign_df, file="data/interim/campaign.csv", sep=";", row.names=FALSE)
remove(campaign_df)

###########################################################################
# Fourth partition: macroeconomic factors at play
macro_econ_colnames <- c("emp.var.rate", "cons.price.idx", "cons.conf.idx", "euribor3m", "nr.employed", "y")
macro_econ_df <- select(df, macro_econ_colnames)
write.table(macro_econ_df, file="data/interim/macro_econ.csv", sep=";", row.names=FALSE)
remove(macro_econ_df)


