rm(list = ls())

source("code/R_setup_params.R")
load("output/hyper_grid.Rdata")
load("input/DF_tmp.Rdata")
file_in = DF_train_vert_name#get all the vertebrates for haddock scores
DF_gbm = read.csv(file_in)
load("output/performance_out.Rdata")#load 
load("input/df_model.Rdata")

output_name = as.character(df_model$output_name)
label = df_model$label
distribution_name = df_model$distribution_name
fields_list = c("haddock_score_mean", "false_negative", "false_positive", 
                "true_negative", "true_positive", "outcome")
fields_list = c(fields_list,
                "predictions_mean"    ,"predictions_sd")

load(paste0("output/OUT_rand_", output_name, ".Rdata"))

if (df_model$taxa == "mammal" & (df_model$label == "haddock_infected_and_below" | df_model$label == "AA_30_negative")){#if it's mammals and it's haddock_infected_and_below, then we're bootstrapping predictions
  load(paste0("output/OUT_obs_predicted", output_name, ".Rdata"))
  I <- OUT_obs_predicted[[1]]
  C <- OUT_obs_predicted[[3]]
  
} else {#if it's vertebrates, or if it's mammals and haddock_score_mean, then we skip the bootstrapping of predictions
  load(paste0("output/OUT_observed_", output_name, ".Rdata"))
  I <- OUT_obs[[1]]
  C <- OUT_obs[[3]]
  }

print("observed data, eval train")
print(mean(I$eval_train))

print("observed data, eval test")
print(mean(I$eval_test))

print("observed data, sd eval test")
print(sd(I$eval_test))

R <- OUT_rand[[1]]
print("null data, eval train")
mean(R$eval_train)
print("null data, eval test")
print(mean(R$eval_test))




C <- C %>% group_by(id_field_vals) %>%
  summarize(predictions_mean = mean(predictions),
            predictions_sd = sd(predictions))
names(C)[names(C)=="id_field_vals"]=id_field
DF_merge = merge(DF, C)
outcome = rep("undefined", dim(DF_merge)[1])
DF_merge$outcome = outcome
DF_merge = DF_merge[,c(id_field, label, "predictions_mean"    ,"predictions_sd" , "outcome")]
# DF_merge = DF_merge[,c(id_field, label, "outcome")]
DF_merge = merge(DF_merge, DF_gbm)

if (distribution_name == "gaussian"){
  corrected_test_eval = mean(I$eval_test) - abs(mean(R$eval_test))#if it's negative pseudo-R2 then subtract the abs value
  DF_merge$true_negative = NA
  DF_merge$true_positive = NA
  DF_merge$false_negative = NA
  DF_merge$false_positive = NA
  DF_merge$outcome = "gaussian"
  true_positive_count = NA
  false_positive_count = NA
  true_negative_count = NA
  false_negative_count = NA
} else {
  corrected_test_eval = mean(I$eval_test) - (mean(R$eval_test) - 0.5)
  DF_merge$predictions_binary = round(DF_merge$predictions_mean)
  
  true_negative = rep(0, dim(DF_merge)[1])
  inds = which(DF_merge[,label]==0 & DF_merge$predictions_binary==0)
  outcome[inds]="true_negative"
  true_negative[inds] = 1
  DF_merge$true_negative = true_negative
  print("true negative")
  true_negative_count = length(inds)
  print(length(inds))
  
  true_positive = rep(0, dim(DF_merge)[1])
  inds = which(DF_merge[,label]==1 & DF_merge$predictions_binary==1)
  outcome[inds]="true_positive"
  true_positive[inds] = 1
  DF_merge$true_positive = true_positive
  print("true positive")
  true_positive_count = length(inds)
  print(length(inds))
  
  false_negative = rep(0, dim(DF_merge)[1])
  inds = which(DF_merge[,label]==1 & DF_merge$predictions_binary==0)#it's really positive but was predicted to be negative
  outcome[inds]="false_negative"
  
  false_negative[inds] = 1
  DF_merge$false_negative = false_negative
  false_negative_count = length(inds)
  print("false negative")
  
  print(length(inds))
  print("false negative species")
  print(DF_merge$Species[inds])
  
  false_positive = rep(0, dim(DF_merge)[1])
  inds = which(DF_merge[,label]==0 & DF_merge$predictions_binary==1)#it's really negative but was predicted to be positive
  outcome[inds]="false_positive"
  false_positive[inds] = 1
  DF_merge$false_positive = false_positive
  false_positive_count = length(inds)
  print("false_positive")
  print(length(inds))
  print("false positive species")
  print(DF_merge$Species[inds])
  DF_merge$outcome = outcome
  
  col_inds = which(names(DF_merge) %in%  c(id_field, label, fields_list))
  
  DF_merge = DF_merge[, col_inds] 
  plot <- ggplot(data = DF_merge, aes(x = outcome, y = haddock_score_mean))+
    geom_boxplot()
  
  plot
  ggsave(plot = plot, filename = paste("figure/confusion", "haddock", output_name, ".jpg"))
}

#are all predictors used or only those w/ importance over 1 in the first model (that had all predictors)
if (str_detect(output_name, "over_one") == TRUE){
  which_predictors = "importance_over_one"
} else {
  which_predictors = "all_predictors"
}

#which distribution did the model use
if (str_detect(output_name, "bernoulli") == TRUE){
  distribution_type = "bernoulli" 
} else {
  distribution_type = "gaussian"
}

#did data include imputed data
if (str_detect(output_name, "impute") == TRUE){
  includes_imputed_data = 1 
} else {
  includes_imputed_data = 0
}

#did model include haddock_score_mean as a predictor
if (str_detect(output_name, "include_haddock") == TRUE){
  includes_haddock_score_mean_as_predictor = 1 
} else {
  includes_haddock_score_mean_as_predictor = 0
}

#what taxa is it
if (str_detect(output_name, "mammal") == TRUE){
  taxa = "mammals" 
} else {
  taxa = "vertebrates"
}

#what versionof ForStrat did we use
if (str_detect(output_name, "ForStrat.terrestrial.marine") == TRUE){
  ForStrat.terrestrial.marine =1 
} else {
  ForStrat.terrestrial.marine = 0
}

if (str_detect(output_name, "ForStrat.terrestrial.aquatic") == TRUE){
  ForStrat.terrestrial.aquatic =1 
} else {
  ForStrat.terrestrial.aquatic = 0
}

if (str_detect(output_name, "wild_non_wild") == TRUE){
  wild_non_wild =1 
} else {
  wild_non_wild = 0
}

if (str_detect(output_name, "wild_only") == TRUE){
  wild_only =1 
} else {
  wild_only = 0
}

if (str_detect(output_name, "include_nzv_taxa") == TRUE){
  include_nzv_taxa =1 
} else {
  include_nzv_taxa = 0
}

##get the number of bootstrap runs
bootstrap_runs = max(I$bootstrap_run)

tmp_out = data.frame(label = label,
                     output_name = output_name,
                     which_predictors = which_predictors,
                     distribution = distribution_type,
                     includes_imputed_data = includes_imputed_data,
                     includes_haddock_score_mean_as_predictor = includes_haddock_score_mean_as_predictor,
                     taxa = taxa,
                     ForStrat.terrestrial.marine = ForStrat.terrestrial.marine,
                     ForStrat.terrestrial.aquatic = ForStrat.terrestrial.aquatic,
                     wild_non_wild = wild_non_wild,
                     wild_only = wild_only,
                     n.minobsinnode = hyper_grid$n.minobsinnode,
                     eta = I$eta[1],
                     max_depth = I$max_depth[1],
                     n.trees.mean.observed = mean(I$n.trees),
                     n.trees.sd.observed = sd(I$n.trees),
                     n.trees.mean.null = mean(R$n.trees),
                     n.trees.sd.null = sd(R$n.trees),
                     mean_eval_train_observed = mean(I$eval_train),
                     sd_eval_train_observed = sd(I$eval_train),
                     mean_eval_test_observed = mean(I$eval_test),
                     sd_eval_test_observed = sd(I$eval_test),
                     mean_eval_train_null = mean(R$eval_train),
                     sd_eval_train_null = sd(R$eval_train),
                     mean_eval_test_null = mean(R$eval_test),
                     sd_eval_test_null = sd(R$eval_test),
                     corrected_test_eval = corrected_test_eval,
                     true_positive_count = true_positive_count,
                     false_positive_count = false_positive_count,
                     true_negative_count= true_negative_count,
                     false_negative_count = false_negative_count,
                     bootstrap_runs = bootstrap_runs)

write.csv(tmp_out, file = paste("output/performance", output_name, ".csv"))
print(paste("corrected test eval", output_name))
print(corrected_test_eval)

DF_merge$label = label#what is the outcome being measured

if (label != "haddock_score_mean"){
  label_ind = which(names(DF_merge)==label)
  names(DF_merge)[label_ind]="label_value"#what is the value of the label (y variable)
} else {
  DF_merge$label_value = DF_merge$haddock_score_mean
}
DF_merge$output_name = output_name
setdiff(names(DF_merge_out), names(DF_merge))
setdiff(names(DF_merge), names(DF_merge_out))

# DF_merge_out = rbind(DF_merge_out, DF_merge)#not sure what this was trying to do
write.csv(DF_merge, file = paste("output/predictions", output_name, ".csv"), 
          row.names = FALSE)

performance_out = rbind(performance_out, tmp_out)
save(performance_out, file = "output/performance_out.Rdata")

#get importance scores
source("code/importance.R")
