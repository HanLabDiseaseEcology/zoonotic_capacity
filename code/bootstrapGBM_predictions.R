bootstrapGBM_predictions <- function(DF, DF_predict, label, vars, k_split, distribution = c("bernoulli", "gaussian"), eta, max_depth, nrounds, nruns, bootstrap = c("observed", "null"), method = "cv", cv.folds = 5,
                                     n.minobsinnode=n.minobsinnode,file_label, id_field) {
  model<-as.formula(paste(label, "~",
                          paste(vars, collapse = "+"),
                          sep = ""))
  out_hist = NULL
  #get histogram
  fields = vars
  for (a in 1:length(fields)){
    i.var = which(names(DF)==fields[a])
    h = hist(DF[,i.var], plot = FALSE)
    tmp = data.frame(variable.value = h$mids,
                     value=h$counts/sum(h$counts),#normalize
                     variable.name=fields[a],
                     var = "frequency")
    out_hist = rbind(out_hist, tmp)
  }
  save(out_hist, file = paste0(bootstrap, "hist_", file_label,".Rdata"))#save the histogram outputs
  id_field_vals = DF_predict[,id_field]#get the values for the field that identifies individual data points / rows. DF_predict! ***
  id_field_ind = which(names(DF_predict)==id_field)#find the id field in the DF_predict data.frame
  
  OUT2 <- foreach(i = 1:nruns, .packages = c("gbm", "foreach", "dismo", "caTools", "caret")) %dopar% {
    set.seed(i)
    if(distribution == "bernoulli") {
      DP <- createDataPartition(as.factor(DF[, label]), p = k_split)[[1]]
    } else DP <- createDataPartition(DF[, label], p = k_split)[[1]]
    TRAIN <- DF[DP, ]
    TEST <- DF[-DP, ]  
    case.gbm <- gbm(model,
                    data=TRAIN,
                    distribution = distribution,
                    n.trees = nrounds,
                    shrinkage = eta,
                    cv.folds = cv.folds,
                    interaction.depth = max_depth,
                    bag.fraction = 0.5,
                    verbose = FALSE,
                    n.minobsinnode=n.minobsinnode)
    best.iter <- gbm.perf(case.gbm,method=method,plot.it=FALSE)
    case.gbm$var.levels <- lapply(case.gbm$var.levels, function(x) replace(x, is.infinite(x), 0))
    predictions <- predict(case.gbm, newdata = DF_predict, n.trees = best.iter, type = "response")#*** make predictions for full dataset.
    pred_df = data.frame(predictions = predictions, bootstrap_run = i, 
                         id_field_vals = id_field_vals,
                         label = label,#*** in contrast to bootstrapGBM we aren't including original label
                         k_split = k_split)#add the original value
      #if we are using less than all the data for training and there is a TEST dataset  
      if(distribution == "bernoulli") {
          output2<-predict(case.gbm, newdata=TRAIN, n.trees=best.iter, type="response") 
          output2<-cbind(output2, as.numeric(TRAIN[, label]))
          eval_train <- colAUC(output2[,1],output2[,2])
          if (k_split < 1){
            
            output2 <- predict(case.gbm, newdata = TEST, n.trees=best.iter, type="response") 
            output2 <- cbind(output2,as.numeric(TEST[, label]))
            eval_test <- colAUC(output2[,1],output2[,2])
          } else {
            eval_test = NA#there's no TEST
          }
      } else {
        eval_train = 1-sum((TRAIN[, label] - predict(case.gbm, newdata=TRAIN, n.trees=best.iter, type="response"))^2)/sum((TRAIN[, label] - mean(TRAIN[, label]))^2)
        if (k_split < 1){
          eval_test = 1-sum((TEST[, label] - predict(case.gbm, newdata=TEST, n.trees =best.iter, type="response"))^2)/sum((TEST[, label] - mean(TEST[, label]))^2)
        } else {
            eval_test = NA
        }
      }
    df_importance <- t(as.data.frame(summary(case.gbm)$rel.inf[match(vars, summary(case.gbm)$var)]))
    colnames(df_importance) <- vars
    rownames(df_importance) <- NULL
    pd_out <- lapply(vars, function(m) dplyr::mutate(plot.gbm(case.gbm, i.var = m, return.grid = T), variable.name = m, effect = "marginal.effect", bootstrap_run = i))
    pd_out <- do.call(rbind, lapply(pd_out, function(m) {
      colnames(m)[1:2] <- c("x", "yhat")
      m}))
    out1 <- cbind.data.frame(eta = eta, max_depth = max_depth, n.trees = best.iter, eval_train = mean(eval_train), eval_test = mean(eval_test), bootstrap_run = i, df_importance)
    OUT <- list(out1, pd_out, pred_df)
  }
  out1 <- do.call(rbind, lapply(OUT2, "[[", 1))
  pd_out <- do.call(rbind, lapply(OUT2, "[[", 2))
  pred_df <- do.call(rbind, lapply(OUT2, "[[", 3))
  list(out1, pd_out,pred_df)
}

save(bootstrapGBM_predictions, file = "bootstrapGBM_predictions.Rdata")
