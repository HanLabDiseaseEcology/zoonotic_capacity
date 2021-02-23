rm(list = ls())
source("code/R_setup_params.R")
source("code/R_setup.R")

label = "haddock_score_mean"
if (label == "haddock_score_mean"){
  distribution_name = "gaussian"
} else {
  distribution_name = "bernoulli"
}

file_in = DF_train_vert_name

DF = read.csv(file_in)
source("code/nzv.R")

save(DF, file = "input/DF_tmp.Rdata")
rm_fields = c("nchar", "haddock_score_sd", "X")

df_model = data.frame(taxa = "vertebrates",
                      ForStrat_name = "ForStrat.terrestrial.aquatic",
                      distribution_name = distribution_name,
                      label = label,
                      predictors_name = "all",
                      imputed_name = "no imputation",
                      include_haddock_as_predictor = "NO_haddock",
                      wild_non_wild = "NA",
                      wild_only = "NA"  )

df_model$output_name = unite(data = df_model, col = "output_name")

df_model$rm_fields[1] <- list(rm_fields)
save(df_model, file = "input/df_model.Rdata")
