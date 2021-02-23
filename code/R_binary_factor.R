binary_factor <- function(DF){
  T = DF
  names = names(T)
  binary = NULL
  for (a in 1:length(names)){
    vals = unique(T[,names[a]])
    vals = vals[!is.na(vals)]
    if (length(which(vals==0)) + length(which(vals == -1)) == 2){
      T[,names[a]]=factor(T[,names[a]])
      binary = c(binary, names[a])
      #change to 1 and 0
    }
  }
  T
}
save(binary_factor, file = "output/binary_factor.Rdata")
