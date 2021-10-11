source("code/run_bootstrapGBM_null.R")#Train and test model multiple times, each time computing accuracy statistics and variable importance scores.  
source("code/run_bootstrapGBM_predictions.R")#Run function bootstrapping to fit model and then using model for making predictions with dataset of all mammals with available trait data 
source("code/performance_metrics_predicted.R")#Get performance metrics
