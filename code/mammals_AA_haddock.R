source("code/remove_temp_data.R")
##define model
source("code/wild_only_AA_30_include_haddock.R")
##run grid search
source("code/R_run_gridSearch.R") 
##make plot of all the deviance curves for each parameter set
source("code/deviance_plots_all.R")

eta = 0.0001
max_depth = 2
n.minobsinnode = 2
source("code/deviance_plot_defined.R")
#use parameters
source("code/scripts.R")#do bootstrapping of predictions

##now do one shot of making predictions with all of the available data and with the same set of hyperparameters 
source("code/wild_only_AA_30_include_haddock_one_iteration.R")
source("code/run_bootstrapGBM_predictions_one_iteration.R")

