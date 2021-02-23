source("code/remove_temp_data.R")
##define model
source("code/wild_only_haddock.R")
##run grid search
source("code/R_run_gridSearch.R") 
##make plot of all the deviance curves for each parameter set
source("code/deviance_plots_all.R")

hyper_grid = subset(hyper_grid, eval_test > 0)
ints <- sort.int(hyper_grid$eval_test, decreasing = TRUE, index.return = TRUE)
hyper_grid = hyper_grid[ints$ix,]

#pick the one with the highest eval_test that also has a flat test deviance curve
eta = 0.0001
max_depth = 4
n.minobsinnode = 3
source("code/deviance_plot_defined.R")
#use parameters
source("code/scripts_no_bootstrapped_predictions.R")
