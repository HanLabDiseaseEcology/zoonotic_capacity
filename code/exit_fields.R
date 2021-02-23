exit_fields = function(vars_list, rm_list){
  inds_bad = which(vars_list %in% rm_list)
  if (length(inds_bad)>0){
      knitr::knit_exit()
  }
}