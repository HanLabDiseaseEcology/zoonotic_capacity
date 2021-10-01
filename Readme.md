This repo contains code and data for boosted regression tree modeling of zoonotic capacity. 

The file zoonotic_capacity.Rmd is an R Markdown file suitable for running in RStudio. zoonotic_capacity.Rmd conains code that installs the necessary packages and sources *.R scripts (in folder "code") to carry out the modeling. zoonotic_capacity.Rmd contains short descriptions of what each *.R file does.  

The "input" folder has *.csv files for training alternative models and using models to make predictions. For example, the file input/MammalTrainingData080221_NvAdded.csv contains data on wild mammal species. Definitions of predictor fields can be found in the Supplementary Tables and Figures (Supplementary Table 2) in the figshare repo: https://doi.org/10.25390/caryinstitute.c.5293339  

To reproduce analyses, download or clone repo and run code found in zoonotic_capacity.Rmd. 
