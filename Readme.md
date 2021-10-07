This repo contains code and data for boosted regression tree modeling of zoonotic capacity. 

The file zoonotic_capacity.Rmd is an R Markdown file suitable for running in RStudio. zoonotic_capacity.Rmd contains code that installs and loads the necessary packages and sources *.R scripts (in folder "code") to carry out the modeling. zoonotic_capacity.Rmd contains short descriptions of what each *.R file does.  

The "input" folder has *.csv files for training models and using models to make predictions. The file input/MammalTrainingData080221_NvAdded.csv contains training data on wild mammal species used for making the highest-accuracy zoonotic capacity model. The file MammalPredictionData231220_wildCategory.csv contains trait data for 5,400 mammals and is used for making predictions based on the fitted zoonotic capacity model. Definitions of predictor fields can be found in the Supplementary Tables and Figures (Supplementary Table 2) in the figshare repo: https://doi.org/10.25390/caryinstitute.c.5293339  

To reproduce analyses, download or clone repo and run the code found in zoonotic_capacity.Rmd. 
