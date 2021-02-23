load("input/df_model.Rdata")

deviance_name = "all"
load(paste0("output/GRID", ".", df_model$output_name, ".Rdata"))

PLTS <-lapply(1:length(unique(GRID[[2]]$group)), function(i) GRID[[2]] %>% filter(group == unique(GRID[[2]]$group)[i]) %>% ggplot() +
                geom_line(aes(x = index, y = train), color = "black", size = 1) +
                geom_line(aes(x = index, y = valid), color = "green", size = 1) +
                geom_vline(xintercept = GRID[[2]] %>% filter(group == unique(GRID[[2]]$group)[i]) %>% dplyr::select(best.iter) %>% unique %>% as.numeric, color = "blue", linetype = "dashed", size = 1) +
                labs(x = "Iteration", y = "Bernoulli deviance", title = unique(GRID[[2]]$group)[i]) +
                theme(panel.background = element_blank(), panel.border = element_rect(fill = "transparent", color = "black", size = 1), panel.grid.major = element_line(color = "grey90"), title = element_text(size = 8)))

patchwork::wrap_plots(PLTS)

filename = paste0("figure/PLTS", ".", "deviance.", df_model$output_name, ".png")
ggsave(filename, width = 18, height = 14)

