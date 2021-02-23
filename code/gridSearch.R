######Parameterization function for gbm
##The gridSearch function takes a variety of variables:
#DF - a data.frame of your label and predictor variables
#label - column name of your label column
#vars - predictor variable column names (may be easiest to use the colnames function and index out the label column)
#k_split - percentage of the data to use for training
#distribution to use for gbm (currently tested with bernoulli and gaussian), bernoulli is the default
#eta - learning rate vector to iterate through, default is set to 0.001, 0.01, and 0.1
#max_depth - depth vector to iterate through, default is set to 1, 2, and 3
#nrounds - max number of trees to set
#method - set at cv, haven't played around with this much
#cv.folds - number of folds to use with gbm
#n.minobsinnode -
######
##Example
#packages <- c("gbm", "caret", "Matrix", "pdp", "caTools", "ROCR", "dplyr", "foreach", "dismo", "doSNOW", "parallel")
#sapply(packages, library, character.only = T)
#detectCores()
#cl <- makeCluster(20, "SOCK")
#registerDoSNOW(cl)
#balt <- gridSearch(DF, label = "Presence", vars = colnames(DF)[-1], k = 5, distribution = "bernoulli", nrounds = 300000)
######
gridSearch <- function(DF, label, vars, k_split, distribution = c("bernoulli", "gaussian"), eta = c(0.001, 0.01, 0.1), max_depth = c(1, 2, 3), n.minobsinnode = c(2, 5, 10), nrounds, method = "cv", cv.folds = 5) {
  model<-as.formula(paste(label, "~",
                          paste(vars, collapse = "+"),
                          sep = ""))
  if(distribution == "bernoulli") {
    DP <- createDataPartition(as.factor(DF[, label]), p = k_split)[[1]]
  } else DP <- createDataPartition(DF[, label], p = k_split)[[1]]
  TRAIN <- DF[DP, ]
  TEST <- DF[-DP, ]
  OUT <- foreach(i = 1:length(eta), .packages = c("gbm", "foreach", "caTools"), .combine = "c") %dopar% {
    foreach(j = 1:length(max_depth), .packages = c("gbm", "caTools"), .combine = "c") %dopar% {
      foreach(m = 1:length(n.minobsinnode), .packages = c("gbm", "caTools"), .combine = "c") %dopar% {
        case.gbm <- gbm(data=TRAIN,
                        model,
                        distribution = distribution,#default
                        n.trees = nrounds,
                        shrinkage = eta[i],
                        cv.folds = cv.folds,
                        interaction.depth = max_depth[j],
                        bag.fraction = 0.5,
                        verbose = FALSE,
                        n.minobsinnode = n.minobsinnode[m])#default
        best.iter <- gbm.perf(case.gbm,method=method,plot.it=FALSE) #this gives you the optimal number of trees 
        ## predictions on the TRAINING SET
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
        list(cbind.data.frame(eta = eta[i], max_depth = max_depth[j], n.minobsinnode = n.minobsinnode[m], n.trees = best.iter, eval_train = mean(eval_train), eval_test = mean(eval_test),
                              group = paste("eta:", eta[i], ", ", "max depth:", max_depth[j], ", ", "min obs in node:", n.minobsinnode[m], sep = "")), 
             cbind.data.frame(index = 1:length(case.gbm$train.error), train = case.gbm$train.error, valid = case.gbm$cv.error, best.iter = best.iter, 
                              group = paste("eta:", eta[i], ", ", "max depth:", max_depth[j], ", ", "min obs in node:", n.minobsinnode[m], sep = "")))
      }
    }
  }
  list(do.call(rbind.data.frame, OUT[which(1:54 %% 2 == 1)]), do.call(rbind.data.frame, OUT[which(1:54 %% 2 == 0)]))
}
# save(gridSearch, file = "gridSearch.Rdata")