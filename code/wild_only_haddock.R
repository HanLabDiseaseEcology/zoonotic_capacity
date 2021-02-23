rm(list = ls())
source("code/R_setup_params.R")
source("code/R_setup.R")

  file_in = DF_train_mammal_name_wild_only
  DF = read.csv(file_in)
  source("code/nzv.R")
  
  save(DF, file = "input/DF_tmp.Rdata")
  #data for all mammals for predictions
  rm_fields = c("nchar", "haddock_score_sd", "traits_wild")
  
  df_model = data.frame(taxa = "mammal",
                        ForStrat_name = "ForStrat.terrestrial.aquatic",
                        distribution_name = "gaussian",
                        label = "haddock_score_mean",
                        predictors_name = "all",
                        imputed_name = "imputed",
                        include_haddock_as_predictor = "NO_haddock",
                        wild_non_wild = "non_wild_excluded",
                        wild_only = "wild_only"  )
    df_model$output_name = unite(data = df_model, col = "output_name")
  
  df_model$rm_fields[1] <- list(rm_fields)
  save(df_model, file = "input/df_model.Rdata")
  