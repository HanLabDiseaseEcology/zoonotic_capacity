hyper_manual(eta, max_depth,n.minobsinnode)

load("input/df_model.Rdata")

deviance_name = "one"
load(paste0("output/GRID", ".", df_model$output_name, ".Rdata"))

load("output/hyper_grid.Rdata")

group_tmp = paste("eta:", hyper_grid$eta, ", ", "max depth:", hyper_grid$max_depth, ", ", "min obs in node:", hyper_grid$n.minobsinnode, sep = "")
GRID[[2]] = subset(GRID[[2]], group == group_tmp)
PLTS <-lapply(1:length(unique(GRID[[2]]$group)), function(i) GRID[[2]] %>% filter(group == unique(GRID[[2]]$group)[i]) %>% ggplot() +
                geom_line(aes(x = index, y = train), color = "black", size = 1) +
                geom_line(aes(x = index, y = valid), color = "green", size = 1) +
                geom_vline(xintercept = GRID[[2]] %>% filter(group == unique(GRID[[2]]$group)[i]) %>% dplyr::select(best.iter) %>% unique %>% as.numeric, color = "blue", linetype = "dashed", size = 1) +
                labs(x = "Iteration", y = "Bernoulli deviance", title = unique(GRID[[2]]$group)[i]) +
                theme(panel.background = element_blank(), panel.border = element_rect(fill = "transparent", color = "black", size = 1), panel.grid.major = element_line(color = "grey90"), title = element_text(size = 8)))

patchwork::wrap_plots(PLTS)

filename = paste0("figure/", deviance_name, ".", "deviance.", df_model$output_name, ".png")
ggsave(filename, width = 5, height = 5)

