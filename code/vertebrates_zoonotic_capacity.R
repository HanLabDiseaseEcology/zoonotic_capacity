source("code/remove_temp_data.R")
source("code/vert_zoonotic_capacity_model.R")#make the model

##run grid search
source("code/R_run_gridSearch.R") 
##make plot of all the deviance curves for each parameter set
source("code/deviance_plots_all.R")

hyper_grid = GRID[[1]]
ints <- sort.int(hyper_grid$eval_test, decreasing = TRUE, index.return = TRUE)
hyper_grid = hyper_grid[ints$ix,]
hyper_grid

eta = 0.0001
max_depth = 2
n.minobsinnode = 2
source("code/deviance_plot_defined.R")

#use parameters
source("code/scripts_no_bootstrapped_predictions.R")
