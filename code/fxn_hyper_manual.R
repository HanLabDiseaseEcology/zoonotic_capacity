hyper_manual <- function(eta, 
                        max_depth,
                        n.minobsinnode){
  hyper_grid = data.frame(eta = eta,
                          max_depth = max_depth,
                          n.minobsinnode = n.minobsinnode)
  save(hyper_grid, file = "output/hyper_grid.Rdata")
}
