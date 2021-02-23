rm(list = ls())
source("code/R_setup_params.R")

k_split = k_split_predictions
source("code/R_setup.R")

load("input/DF_tmp.Rdata")

load("input/DF_predict.Rdata")
DF_predict = binary_factor(DF_predict)

load("input/df_model.Rdata")

load("output/hyper_grid.Rdata")

load("output/pred_sum_out.Rdata")

DF_predict = R_add_field(DF, DF_predict, "AA_83_Y")    
DF_predict = R_add_field(DF, DF_predict, "AA_30_negative")    
DF_predict = R_add_field(DF, DF_predict, "haddock_score_mean")    

print(Sys.time())

source("code/fields_for_gbm.R")

if (df_model$label == "AA_30_negative"){
  nruns = 10#if it's AA 30 negative then we're not doing as many bootstrap iterations
} else {
  nruns = nruns_predictions
}

##commented out code for debugging
# label = df_model$label
# file_label=df_model$output_name
# bootstrap = 1
# i =1
# distribution= "bernoulli"
# cv.folds = 5
# method = "cv"
OUT_obs_predicted <- bootstrapGBM_predictions(DF = DF, DF_predict = DF_predict, 
                                              label = df_model$label, vars = vars, 
                                              k_split = k_split, distribution = df_model$distribution_name, 
                        eta = hyper_grid$eta, max_depth = hyper_grid$max_depth, 
                        nrounds = nrounds, nruns = nruns, 
                        bootstrap = "observed", method = "cv", cv.folds = cv.folds,
                        n.minobsinnode = hyper_grid$n.minobsinnode,
                        file_label=df_model$output_name, id_field = id_field)

save(OUT_obs_predicted, file = paste0("output/OUT_obs_predicted", df_model$output_name, ".Rdata"))

#summarize across runs

perc.rank <- function(x) 100*trunc(rank(x))/length(x)

tmp = OUT_obs_predicted[[3]]
out = NULL
for (a in 1:nruns_predictions){
  df <- subset(tmp, bootstrap_run == a)
  rank_value = dim(df)[1]-rank(df$predictions)
  percentile_value = perc.rank(df$predictions)
  df$rank = rank_value
  df$percentile = percentile_value
  out = rbind(out, df)
}

tmp1 <- out %>% group_by(id_field_vals) %>%
  summarise(bootstrap_runs = max(bootstrap_run),
            predicted_mean = mean(predictions),
            predicted_sd = sd(predictions),
            predicted_max = max(predictions),
            predicted_min = min(predictions),
            percentile_mean = mean(percentile),
            percentile_sd = sd(percentile),
            percentile_max = max(percentile),
            percentile_min = min(percentile),
            rank_mean = mean(rank),
            rank_sd = sd(rank),
            rank_max = max(rank),
            rank_min = min(rank)
  )

tmp1 = data.frame(tmp1)
tmp1 <- cbind(tmp1, df_model$label)
tmp1 <- cbind(tmp1, df_model$predictors_name)
tmp1 <- cbind(tmp1, df_model$taxa)
tmp1 <- cbind(tmp1, df_model$imputed_name)
tmp1 <- cbind(tmp1, df_model$include_haddock_as_predictor)

names(tmp1)[names(tmp1)=="df_model$label"]="label"
names(tmp1)[names(tmp1)=="df_model$predictors_name"]="predictors_name"
names(tmp1)[names(tmp1)=="df_model$taxa"]="taxa"
names(tmp1)[names(tmp1)=="df_model$imputed_name"]="imputed_name"
names(tmp1)[names(tmp1)=="df_model$include_haddock_as_predictor"]="include_haddock_as_predictor"
tmp1$proportion_of_data_used_for_training = k_split

load("input/DF_tmp.Rdata")

#read in the best set of predictions for with haddock
names(tmp1)[names(tmp1)=="id_field_vals"]="Species"

tmp1 <- R_add_field(DF, tmp1, "AA_83_Y")
tmp1 <- R_add_field(DF, tmp1, "AA_30_negative")

tmp1 <- R_add_field(DF, tmp1, "haddock_score_mean")
tmp1 <- R_add_field(DF = DF_predict, DF_predict = tmp1, "ForStrat_aquatic")
tmp1 <- R_add_field(DF_predict, tmp1, "ForStrat_terrestrial")

tmp1 <- cbind(tmp1, df_model$output_name)

test_1 = subset(tmp1, !is.na(haddock_score_mean))
print(test_1[1,])

test_0 = subset(tmp1, is.na(haddock_score_mean))
print(test_0[1,])

# print("AA_83_Y)")
test_1 = subset(tmp1, !is.na(AA_83_Y))
print(test_1[2,])

test_0 = subset(tmp1, is.na(AA_83_Y))
print(test_0[2,])

rm= "label.1"
keep = setdiff(names(tmp1), rm)
tmp1 = tmp1[,keep]
DF = tmp1
source("code/R_haddock_infected_and_below_129.R")#assign haddock_infected_and_below  
tmp1 = DF


write.csv(tmp1, file = paste("output/", df_model$output_name, "prediction summary rank label.csv"), row.names = FALSE)

print(Sys.time())