names_df = names(DF)

#remove variables with near zero variation
sp_ind = which(names(DF)=="Species")
#Use a 95/5 ratio as "the cutoff for the ratio of the most common value to the second most common value" (quoting definition from function documentation)
nzv = nearZeroVar(DF, freqCut = 95/5, saveMetrics = TRUE)
okay_inds = which(nzv$nzv == FALSE)

near_zero_inds =which(nzv$nzv == TRUE)
print("near zero variation fields")
print(names_df[near_zero_inds])

DF = DF[,c(okay_inds)]#include only the columns that have variation; also include adult_svl_cm because it looks like it does have variation

