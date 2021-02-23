source("code/remove_temp_data.R")
#define model
source("code/wild_non_wild_zoonotic_capacity_model.R")

##run grid search
source("code/R_run_gridSearch.R") 
##make plot of all the deviance curves for each parameter set
source("code/deviance_plots_all.R")

hyper_grid = subset(hyper_grid, eval_test > 0)
ints <- sort.int(hyper_grid$eval_test, decreasing = TRUE, index.return = TRUE)
hyper_grid = hyper_grid[ints$ix,]

eta = 0.0001
max_depth = 2
n.minobsinnode = 5

#use parameters
source("code/deviance_plot_defined.R")
#use parameters
source("code/scripts.R")


