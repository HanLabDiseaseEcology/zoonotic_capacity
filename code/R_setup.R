source("code/gridSearch.R")#Define function gridSearch, which performs grid search by looping through all possible combinations of hyperparameters we define 
#and saving accuracy statistics and data for plotting deviance curves. The alternative hyperparameter values we considered were eta (learning rate)
# of 0.0001, 0.001, 0.01, or 0.1; maximum interaction depth across variables of 2, 3, or 4, and minimum number of observations in trees' terminal nodes of 2, 3, 4, or 5.

source("code/bootstrapGBM_predictions.R")#Define function bootstrapGBM_predictions, which we use to fit and evaluate model multiple times using the same set of hyperparameters.
#At each iteration (bootstrap run), the function computes and saves training and test evaluation statistics, predictor variable importance scores,
#data for making partial dependence plots. Finally, this function also makes predictions for an input dataframe that includes records with predictor variables but no labels.
#For the zoonotic capacity model we used to make predictions for 5,400 mammals, this is the function we used. 

source("code/bootstrapGBM.R")#Define function bootstrapGBM, a function that does everything in bootstrapGBM_prediction except make predictions for a dataframe including unlabeled records. 
#We used this function for relatively uninformative models that we did not use to make predictions. This function would be needed to reproduce model-fitting for the relatively uninformative models.  

source("code/R_add_field.R")#Helper function to add a field from one dataframe to another

source("code/exit_fields.R")#Helper function to double-check that only those predictors that are needed for a model are included.  

source("code/fxn_hyper_manual.R")#Helper function to define one set of user-chosen hyperparameters. 

source("code/R_binary_factor.R")#Helper function to set to factor any predictor variable that has a binary (1 or 0) value, to ensure gbm treats these predictors as factor rather than continuous.

