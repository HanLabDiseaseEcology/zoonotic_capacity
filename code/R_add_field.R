R_add_field = function(DF, DF_predict, field_to_add){
out = NULL
DF_predict_obs_inds = which(DF_predict$Species %in% DF$Species)#species we have no info about
DF_predict_obs = DF_predict[DF_predict_obs_inds,]
DF_1_field = DF[, c("Species", field_to_add)]
DF_predict_obs = merge(DF_predict_obs, DF_1_field)

DF_predict_new_inds = setdiff(seq(1:dim(DF_predict)[1]),DF_predict_obs_inds)#rows that haven't had ACE2 sequenced
if (length(DF_predict_new_inds)>0){
  DF_predict_new = DF_predict[DF_predict_new_inds,]
  DF_predict_new[,field_to_add] <- NA
  rownames(DF_predict_new) <- c()
  out = rbind(out, DF_predict_new)
}

rownames(DF_predict_obs) <- c()

out = rbind(out, DF_predict_obs)
DF_predict <- out
DF_predict
}