haddock_infected_and_below = rep(NA, dim(DF)[1])#default is that you have a haddock score that is above species infectable and w/ highest score

haddock_cutoff = -129
inds_equal_and_lower = which(DF$haddock_score_mean <= haddock_cutoff)
haddock_infected_and_below[inds_equal_and_lower] = 1

inds_greater = which(DF$haddock_score_mean > haddock_cutoff)
haddock_infected_and_below[inds_greater] = 0

DF$haddock_infected_and_below = haddock_infected_and_below

rm = which(names(DF) %in% c( "Order",  "nchar", "haddock_score_sd"))

if (length(rm)>0){
  DF = DF[,-rm]
}

