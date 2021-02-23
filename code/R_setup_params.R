testing_var = 1#0: testing things out, not doing as full of grid search

k_split_performance = 0.8
k_split_predictions = 0.8

cv.folds = 10
print(Sys.time())
id_field = "Species"
rm_list = c("nchar", "Order",  "haddock_score_sd")
if (testing_var == 1){
  eta = c(0.0001, 0.001, 0.01, 0.1)
  max_depth = c(2,3,4)
  n.minobsinnode = c(2,3,4,5)
  nrounds = 100000
  min_trees_threshold = 10000
  nruns = 10
  nruns_predictions = 50#3
  
} else {
  eta = c(0.0001)
  max_depth = c(2)
  n.minobsinnode = c(5)
  nrounds = 100000
  nruns = 2
  nruns_predictions = 2#3
}

DF_merge_out = NULL#this will have the mean predictions

DF_train_mammal_name_wild_non_wild =     "input/MammalTrainingData231220_wildCategory_NvAdded.csv"#this includes wild and non-wild species

DF_train_mammal_name_wild_only =     "input/MammalTrainingData080221_NvAdded.csv"#this only has wild species

DF_predict_mammal_name_wild_non_wild = "input/MammalPredictionData231220_wildCategory.csv"#this includes the wild vs non-wild field

DF_train_vert_name= "input/VertsTrainingData080221_NvHaddockadded.csv"
