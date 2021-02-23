rm(list = ls())
source("code/R_setup_params.R")

k_split = k_split_performance#this is something less than 1

load("input/df_model.Rdata")

source("code/R_setup.R")
load("input/DF_tmp.Rdata")

source("code/fields_for_gbm.R")

output_name = df_model$output_name
load("output/hyper_grid.Rdata")
print(Sys.time())

#since we are setting seed, this will always be the same
OUT_rand <- bootstrapGBM(DF = DF, label = df_model$label, vars = vars, k_split = k_split, distribution = df_model$distribution_name, eta = hyper_grid$eta, max_depth = hyper_grid$max_depth, nrounds = nrounds, nruns = nruns, 
                         bootstrap = "null", method = "cv", cv.folds = cv.folds,
                         n.minobsinnode = hyper_grid$n.minobsinnode, file_label = "null", id_field = id_field)

save(OUT_rand, file = paste0("output/OUT_rand_", output_name, ".Rdata"))

print(Sys.time())