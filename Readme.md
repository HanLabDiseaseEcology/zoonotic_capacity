This repo contains code and data for boosted regression tree modeling of zoonotic capacity. 

To reproduce analyses, download or clone this repo and run the R code found in zoonotic_capacity.Rmd. 

The file zoonotic_capacity.Rmd is an R Markdown file suitable for running in RStudio. zoonotic_capacity.Rmd contains code that installs and loads the necessary packages and sources *.R scripts (in folder "code") to carry out the modeling. zoonotic_capacity.Rmd contains short descriptions of what each *.R file does.  

Briefly, here are the steps implemented in the code (numbers here match numbers in zoonotic_capacity.Rmd):

1. Install and load needed packages. 

2. Make folders for outputs. 

3. Initialize cores used for parallel processing in modeling. 

4. Define the data for training and evaluating the model, and for using the model to make predictions. The "input" folder in this repo has *.csv files for training models and using models to make predictions. The file input/MammalTrainingData080221_NvAdded.csv contains training data on wild mammal species used for making the highest-accuracy zoonotic capacity model. The file MammalPredictionData231220_wildCategory.csv contains trait data for 5,400 mammals and is used for making predictions based on the fitted zoonotic capacity model. Definitions of predictor fields can be found in the Supplementary Tables and Figures (Supplementary Table 2) in the figshare repo: https://doi.org/10.25390/caryinstitute.c.5293339    

5. Run grid search to evaluate and select hyperparameters for boosted regression tree modeling. We evaluate several alternative learning rates, maximum interaction depths, and number of minimum observations in terminal nodes. For each both possible combination of learning rate, interaction depth, and minimun observations, we fit a boosted regression tree model and evaluate its accuracy. We then make plots of the deviance curves for each hyperparameter combination set. We select for modeling the hyperparameter set that has the best accuracy (test AUC), while also having a relatively flat test deviance curve indicating the model has converged.   

6. Using the hyperparameters chosen through grid search, fit boosted regression tree models. Bootstrap modeling, fitting multiple models with different seeds for training and test splits of the data. Bootstrapping generates distributions of evaluation test AUC, variable importance scores, and predicted zoonotic capacities across 5,400 mammals. A separate set of null model bootstrapping, in which labels are shuffled prior to model fitting, enables computing a corrected test AUC. Label shuffling allows for correcting the test AUC for any potential effects of structure in the data that may influence AUC without reflecting meaningful relationships to the labels. 

7. Using all of the available training data (rather than with a training and test split), fit one model to use in making predictions across all 5,400 mammals. 

8. Code (commented out) for carrying out steps 1 through 7 to reproduce alternative models that were relatively uninformative (e.g., of binding strength as a continuous measure, or of ACE2 amino acid charge at position 30).  



