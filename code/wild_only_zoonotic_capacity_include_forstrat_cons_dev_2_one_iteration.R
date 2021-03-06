rm(list = ls())
source("code/R_setup_params.R")
source("code/R_setup.R")

file_in = DF_train_mammal_name_wild_only
  DF = read.csv(file_in)
  source("code/R_haddock_infected_and_below_129.R")#assign haddock_infected_and_below  
  source("code/nzv.R")
  
  save(DF, file = "input/DF_tmp.Rdata")
  #data for all mammals for predictions
  DF_predict = read.csv(DF_predict_mammal_name_wild_non_wild) 
  DF_predict = subset(DF_predict, select = -c(traits_wild) )
  DF_predict = R_add_field(DF, DF_predict, "haddock_infected_and_below")
  save(DF_predict, file = "input/DF_predict.Rdata")
  
  rm_fields = c("nchar", "haddock_score_sd", "haddock_score_mean", "traits_wild")
  
  df_model = data.frame(taxa = "mammal",
                        ForStrat_name = "ForStrat.terrestrial.aquatic",
                        distribution_name = "bernoulli",
                        label = "haddock_infected_and_below",
                        predictors_name = "all_predictors",
                        imputed_name = "imputed",
                        include_haddock_as_predictor = "NO_haddock_as_pred",
                        wild_non_wild = "non_wild_excluded",
                        wild_only = "wild_only",
                        deviance = "cons_depth_2",
                        iterations = "one_iter"
  )
  df_model$output_name = unite(data = df_model, col = "output_name")
  
  df_model$rm_fields[1] <- list(rm_fields)
  save(df_model, file = "input/df_model.Rdata")
  # source("code/scripts.R")  
