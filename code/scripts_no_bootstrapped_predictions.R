#set up for bootstrapping predictions
rm(list = ls())
source("code/R_setup_params.R")
source("code/run_bootstrapGBM_observed_null.R")#this will use nruns which is 10
source("code/performance_metrics_predicted.R")
