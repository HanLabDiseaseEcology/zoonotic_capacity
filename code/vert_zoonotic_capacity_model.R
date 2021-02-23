rm(list = ls())
source("code/R_setup_params.R")
source("code/R_setup.R")

file_in = DF_train_vert_name

DF = read.csv(file_in)
source("code/R_haddock_infected_and_below_129.R")#assign haddock_infected_and_below  
source("code/nzv.R")

save(DF, file = "input/DF_tmp.Rdata")
rm_fields = c("nchar", "haddock_score_sd", "haddock_score_mean", "X")

df_model = data.frame(taxa = "vertebrates",
                      ForStrat_name = "ForStrat.terrestrial.aquatic",
                      distribution_name = "bernoulli",
                      label = "haddock_infected_and_below",
                      predictors_name = "all",
                      imputed_name = "no imputation",
                      include_haddock_as_predictor = "NO_haddock",
                      wild_non_wild = "NA",
                      wild_only = "NA"  )

df_model$output_name = unite(data = df_model, col = "output_name")

df_model$rm_fields[1] <- list(rm_fields)
save(df_model, file = "input/df_model.Rdata")
