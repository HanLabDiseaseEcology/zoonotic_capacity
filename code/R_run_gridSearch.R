set.seed(1)
load("input/DF_tmp.Rdata")

k_split = k_split_performance
source("code/R_setup.R")
load("input/df_model.Rdata")

source("code/fields_for_gbm.R")

GRID <- gridSearch(DF = DF, label = df_model$label, vars = vars, k_split = k_split, 
                   distribution = df_model$distribution_name, 
                   eta = eta, 
                   max_depth = max_depth, 
                   n.minobsinnode = n.minobsinnode,
                   nrounds = nrounds, 
                   method = "cv", 
                   cv.folds = cv.folds)

hyper_grid = GRID[[1]]
dev <- GRID[[2]]
save(GRID, file = paste0("output/GRID", ".", df_model$output_name, ".Rdata"))
save(hyper_grid, file = paste0("output/hyper_grid", ".", df_model$output_name, ".Rdata"))
print(Sys.time())
