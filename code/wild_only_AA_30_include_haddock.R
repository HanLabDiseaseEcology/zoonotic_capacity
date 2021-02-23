rm(list = ls())
source("code/R_setup_params.R")
source("code/R_setup.R")

label = "AA_30_negative"
if (label == "haddock_score_mean"){
  distribution_name = "gaussian"
} else {
  distribution_name = "bernoulli"
}

  file_in = DF_train_mammal_name_wild_only
  DF = read.csv(file_in)
  source("code/nzv.R")
  
  save(DF, file = "input/DF_tmp.Rdata")
  #data for all mammals for predictions
  rm_fields = c("nchar", "haddock_score_sd", "traits_wild")#leave in haddock score

  DF_predict = read.csv(DF_predict_mammal_name_wild_non_wild) 
  DF_predict = subset(DF_predict, select = -c(traits_wild) )
  save(DF_predict, file = "input/DF_predict.Rdata")
    
  df_model = data.frame(taxa = "mammal",
                        ForStrat_name = "ForStrat.terrestrial.aquatic",
                        distribution_name = distribution_name,
                        label = label,
                        predictors_name = "all",
                        imputed_name = "imputed",
                        include_haddock_as_predictor = "include_haddock_as_predictor",
                        wild_non_wild = "non_wild_excluded",
                        wild_only = "wild_only"  )
  df_model$output_name = unite(data = df_model, col = "output_name")
  
  df_model$rm_fields[1] <- list(rm_fields)
  save(df_model, file = "input/df_model.Rdata")
  