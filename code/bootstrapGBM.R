######Bootstrap function for gbm
##The bootstrapGBM function takes a variety of variables:
#DF - a data.frame of your label and predictor variables
#label - column name of your label column
#vars - predictor variable column names (may be easiest to use the colnames function and index out the label column)
#k_split -  percentage of the data to use for training
#distribution to use for gbm (currently tested with bernoulli and gaussian), bernoulli is the default
#eta - learning rate determined from parameterization to use in bootstrapping
#max_depth - depth rate determined from parameterization
#nrounds - max number of trees to set
#nruns - number of bootstrap runs to use
#bootstrap - determines whether to use the observed data or a null distribution for performing the bootstrap
#method - set at cv, haven't played around with this much
#cv.folds - number of folds to use with gbm
######
##Example
#packages <- c("gbm", "caret", "Matrix", "pdp", "caTools", "ROCR", "dplyr", "foreach", "dismo", "doSNOW", "parallel")
#sapply(packages, library, character.only = T)
#detectCores()
#cl <- makeCluster(20, "SOCK")
#registerDoSNOW(cl)
#alt <- bootstrap_gbm(DF, label = "sr", vars = colnames(DF)[-1:-3], eta = 0.001, max_depth = 2, nrounds = 1000, distribution = "gaussian", k = 5, nruns = 5, bootstrap = "observed")
######
##changes since last version on Hanlab github:
##added n.minobsinnode
##avoid using cluster k for train/test split
##added out_hist and saved it
##added file_label for out_hist
bootstrapGBM <- function(DF, label, vars, k_split, distribution = c("bernoulli", "gaussian"), eta, max_depth, nrounds, nruns, bootstrap = c("observed", "null"), method = "cv", cv.folds = 5,
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
  id_field_vals = DF[,id_field]#get the values for the field that identifies individual data points / rows
  OUT2 <- foreach(i = 1:nruns, .packages = c("gbm", "foreach", "dismo", "caTools", "caret")) %dopar% {
    set.seed(i)
    if(distribution == "bernoulli") {
      DP <- createDataPartition(as.factor(DF[, label]), p = k_split)[[1]]
    } else DP <- createDataPartition(DF[, label], p = k_split)[[1]]
    if(bootstrap == "observed") {
      TRAIN <- DF[DP, ]
      TEST <- DF[-DP, ]
    } else {#"null"
      TRAIN <- DF[DP, ]
      TRAIN[, label] <- sample(x = TRAIN[, label], size = nrow(TRAIN), replace = F)
      TEST <- DF[-DP, ]
      TEST[, label] <- sample(x = TEST[, label], size = nrow(TEST), replace = F)
    }
    print("TEST")
    print(dim(TEST)[1])
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
    print("gbm done")
    best.iter <- gbm.perf(case.gbm,method=method,plot.it=FALSE)
    case.gbm$var.levels <- lapply(case.gbm$var.levels, function(x) replace(x, is.infinite(x), 0))
    predictions <- predict(case.gbm, newdata = DF, n.trees = best.iter, type = "response")#make predictions for full dataset.
    pred_df = data.frame(predictions = predictions, bootstrap_run = i, 
                         id_field_vals = id_field_vals,
                         label = label,
                         original_value = DF[,label])#add the original value
    # predictions[,id_field]= id_field_vals
    # predictions$bootstrap_run = i
    # out_predictions <- cbind.data.frame(predictions = predictions, bootstrap_run = i, id_field_vals = id_field_vals)
    if(distribution == "bernoulli") {
      output2<-predict(case.gbm, newdata=TRAIN, n.trees=best.iter, type="response") 
      output2<-cbind(output2, as.numeric(TRAIN[, label]))
      eval_train <- colAUC(output2[,1],output2[,2])
      output2 <- predict(case.gbm, newdata = TEST, n.trees=best.iter, type="response") 
      output2 <- cbind(output2,as.numeric(TEST[, label]))
      eval_test <- colAUC(output2[,1],output2[,2])
    } else {
      eval_train = 1-sum((TRAIN[, label] - predict(case.gbm, newdata=TRAIN, n.trees=best.iter, type="response"))^2)/sum((TRAIN[, label] - mean(TRAIN[, label]))^2)
      eval_test = 1-sum((TEST[, label] - predict(case.gbm, newdata=TEST, n.trees =best.iter, type="response"))^2)/sum((TEST[, label] - mean(TEST[, label]))^2)
    }
    df_importance <- t(as.data.frame(summary(case.gbm)$rel.inf[match(vars, summary(case.gbm)$var)]))
    colnames(df_importance) <- vars
    rownames(df_importance) <- NULL
    pd_out <- lapply(vars, function(m) dplyr::mutate(plot.gbm(case.gbm, i.var = m, return.grid = T), variable.name = m, effect = "marginal.effect", bootstrap_run = i))
    pd_out <- do.call(rbind, lapply(pd_out, function(m) {
      colnames(m)[1:2] <- c("x", "yhat")
      m}))
    out1 <- cbind.data.frame(eta = eta, max_depth = max_depth, n.trees = best.iter, eval_train = mean(eval_train), eval_test = mean(eval_test), bootstrap_run = i, df_importance)
    # OUT <- list(out1, pd_out, predictions)
    OUT <- list(out1, pd_out, pred_df)
  }
  out1 <- do.call(rbind, lapply(OUT2, "[[", 1))
  pd_out <- do.call(rbind, lapply(OUT2, "[[", 2))
  pred_df <- do.call(rbind, lapply(OUT2, "[[", 3))
  # predictions <- do.call(rbind, lapply(OUT2, "[[", 3))
  list(out1, pd_out,pred_df)
}

# save(bootstrapGBM, file = "bootstrapGBM.Rdata")


